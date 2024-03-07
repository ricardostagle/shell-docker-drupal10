#!/bin/bash

docker pull drupal
docker pull mysql
docker pull phpmyadmin

docker run -d --name mysqldemo -e MYSQL_ROOT_PASSWORD=drupal mysql:latest
docker run -d --name phpmyadmindemo -d --link mysqldemo:db -p 8081:80 phpmyadmin:latest
docker run -d --name drupal10 -d --link mysqldemo -p 8090:80 -e MYSQL_USER:root -e MYSQL_PASSWORD:drupal -it --volume //c/web/drupal10/modules:/opt/drupal/web/modules --volume //c/web/drupal10/themes:/opt/drupal/web/themes drupal:latest

sudo apt install unzip && unzip files.zip -d .

docker cp drupal10.sql mysqldemo:.
docker cp settings.php drupal10:/opt/drupal/web/sites/default/
docker cp files/ drupal10:/opt/drupal/web/sites/default/

rm -rf files/

sleep 15
docker exec -i mysqldemo sh -c 'exec mysql -uroot -p$MYSQL_ROOT_PASSWORD < drupal10.sql'

docker exec -i drupal10 sh -c 'exec composer require drupal/pathauto'
docker exec -i drupal10 sh -c 'exec composer require drush/drush'
docker exec -i drupal10 sh -c 'exec drush cr'

# windows command to get in container
#winpty docker exec -it drupal10 bash

#docker exec -it drupal10 /bin/bash

#cd web/sites/default
#composer require drupal/pathauto
#composer require drush/drush
