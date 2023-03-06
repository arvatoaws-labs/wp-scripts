# wp-scripts
General usage
----

These scipts are used in these helm cahrts:

* https://github.com/arvatoaws-labs/wordpress-bedrock-helm-chart
* https://github.com/arvatoaws-labs/wordpress-helm-chart


Admin User Update
----

```
❯ export WORDPRESS_USERNAME=admin
❯ export WORDPRESS_PASSWORD=pw
❯ export WORDPRESS_EMAIL=admin@example.com
❯ export WORDPRESS_USERNAME_2=admin2
❯ export WORDPRESS_PASSWORD_2=pw2
❯ export WORDPRESS_EMAIL_2=admin4@example.com
❯ export WORDPRESS_USERNAME_4=admin4
❯ export WORDPRESS_PASSWORD_4=pw4
❯ export WORDPRESS_EMAIL_4=admin4@example.com
❯ ./update-wp-admin-user.sh
using wordpress-username admin
using wordpress-email admin@example.com
create admin user if not exists otherwise update admin user...
using wordpress-username admin2
using wordpress-email admin2@example.com
create admin user if not exists otherwise update admin user...
using wordpress-username admin4
using wordpress-email admin4@example.com
create admin user if not exists otherwise update admin user..
```
