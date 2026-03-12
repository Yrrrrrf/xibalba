URL="http://127.0.0.1:8000/sql"
xh post "$URL" Accept:application/json surreal-ns:"app" surreal-db:"main" -a "root:super_secret_dev_pass_override_me" --raw "UPDATE item:laptop_01 SET quantity = 48;"
xh post "$URL" Accept:application/json surreal-ns:"app" surreal-db:"main" -a "root:super_secret_dev_pass_override_me" --raw "SELECT * FROM movement;"
