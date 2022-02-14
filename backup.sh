#/bin/bash
################################################## CONFIGURATION #######################################################################>#                                                                                                                                       >     >        rootcatalog="/passwork/backup/" #path to store your backups
        rootcatalog="/backup/path/"
        dbusername="user"         #grant select on database.*, no adidional permissions! for security ;)
        dbpassword='password'
        daystostore="14"                  #days to store your all your backups, script always leaves one from each day
        authenticationDatabase='admin'
        database='dbname'
########################################################################################################################################>
currentdate="$(date +"%d_%m_%Y")"
mkdir $rootcatalog
cd $rootcatalog

outputcatalog="$rootcatalog$currentdate/"
if [ -d "$outputcatalog" ]
then
echo "INFO: Path $outputcatalog Exists"
else
        echo "INFO: Path $outputcatalog did not exist, creating"
        mkdir $currentdate
fi

echo "INFO: Dumping Dababase: $database to: $outputcatalog"
#time=$(date +"%d_%m_%Y_%T") fixed
time=$(date +"%Y_%m_%d_%T")
filename="$database_$time"
path="$outputcatalog$filename"

#mysqldump -u $dbusername -p$dbpassword $database --single-transaction --events --routines --quick --lock-tables=false > $path --roznica od mysql
echo "INFO: mongodump -u $dbusername -p $dbpassword --authenticationDatabase=$authenticationDatabase -d $database -o $path"
mongodump -u $dbusername -p $dbpassword --authenticationDatabase=$authenticationDatabase -d $database -o $path >> mongodump.log

patha="$path.tar.gz"
echo "INFO: Komenda kompresji: GZIP=-9 tar cvzf $patha $path"
GZIP=-9 tar cvzf $patha $path >> compression.log
#rm -f $path --roznica od mysql
echo "rm -R -f $path"
rm -R -f $path

#daytopurge=$(date +%d_%m_%Y -d "$daystostore days ago") #this needs correction?
echo "INFO: DAY TO PURGE $(date +%Y_%m_%d -d "$daystostore days ago")"
daytopurge=$(date +%Y_%m_%d -d "$daystostore days ago")
cd $rootcatalog
if [ -d "$rootcatalog/$daytopurge/" ]
        then
                cd $daytopurge
                ls -1tr | head -n -1 | xargs -d '\n' rm -f --
else
        echo "PATH $rootcatalog$daytopurge/ DOESNT EXIST"
fi