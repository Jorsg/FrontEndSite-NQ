'use strict';

module.exports = {
  register(/* { strapi } */) {},
  async bootstrap({ strapi }) {
    const rolesCount = await strapi
      .query('plugin::users-permissions.role')
      .count();

    if (rolesCount === 0) {
      await strapi.query('plugin::users-permissions.role').create({
        data: {
          name: 'Authenticated',
          description: 'Default role given to authenticated user.',
          type: 'authenticated',
        },
      });

      await strapi.query('plugin::users-permissions.role').create({
        data: {
          name: 'Public',
          description: 'Default role given to unauthenticated user.',
          type: 'public',
        },
      });
    }

    const publicRole = await strapi
      .query('plugin::users-permissions.role')
      .findOne({ where: { type: 'public' } });

    if (publicRole) {
      const permissions = await strapi
        .query('plugin::users-permissions.permission')
        .findMany({ where: { role: publicRole.id } });

      const articleActions = ['api::article.article.find', 'api::article.article.findOne'];

      for (const action of articleActions) {
        const existing = permissions.find((p) => p.action === action);
        if (!existing) {
          await strapi.query('plugin::users-permissions.permission').create({
            data: {
              action,
              role: publicRole.id,
              enabled: true,
            },
          });
        } else if (!existing.enabled) {
          await strapi.query('plugin::users-permissions.permission').update({
            where: { id: existing.id },
            data: { enabled: true },
          });
        }
      }
    }
  },
};
