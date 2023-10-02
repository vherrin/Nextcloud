 #!/bin/bash

PATH=/usr/local/bin:/usr/local/sbin:/usr/sbin:/usr/bin:/sbin:/bin:

/var/www/html/occ app:install maps
/var/www/html/occ app:enable files_external
/var/www/html/occ app:enable bruteforcesettings
/var/www/html/occ app:install files_photospheres
/var/www/html/occ app:install recognize
/var/www/html/occ app:install previewgenerator
#/var/www/html/occ recognize:download-models

echo 'Finished'