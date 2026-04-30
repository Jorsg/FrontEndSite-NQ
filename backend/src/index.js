'use strict';

module.exports = {
  register(/* { strapi } */) {},
  async bootstrap({ strapi }) {
    try {
      const permQuery = strapi.query('plugin::users-permissions.permission');
      const roleQuery = strapi.query('plugin::users-permissions.role');

      let publicRole = await roleQuery.findOne({ where: { type: 'public' } });

      if (!publicRole) {
        console.log('[Bootstrap] Creating default roles...');
        publicRole = await roleQuery.create({
          data: { name: 'Public', description: 'Default role given to unauthenticated user.', type: 'public' },
        });
        const authExists = await roleQuery.findOne({ where: { type: 'authenticated' } });
        if (!authExists) {
          await roleQuery.create({
            data: { name: 'Authenticated', description: 'Default role given to authenticated user.', type: 'authenticated' },
          });
        }
      }

      const requiredActions = [
        'api::article.article.find',
        'api::article.article.findOne',
      ];

      for (const action of requiredActions) {
        const existing = await permQuery.findMany({
          where: { action, role: publicRole.id },
        });

        for (const perm of existing) {
          await permQuery.delete({ where: { id: perm.id } });
        }

        await permQuery.create({
          data: { action, role: publicRole.id },
        });
        console.log(`[Bootstrap] Permission granted: ${action}`);
      }

      console.log('[Bootstrap] Public API permissions configured successfully');
    } catch (error) {
      console.error('[Bootstrap] Failed to configure permissions:', error.message);
    }
  },
};
