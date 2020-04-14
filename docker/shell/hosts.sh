#!/bin/bash

grep -qxF '127.0.0.1 '$1 /var/www/hosts || echo '127.0.0.1 '$1 >> /var/www/hosts