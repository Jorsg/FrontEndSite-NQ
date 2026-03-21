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
  },
};
