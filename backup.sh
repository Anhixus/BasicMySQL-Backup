#/bin/bash
################################################## CONFIGURATION #######################################################################>#                                                                                                                                       >        database="sit45"
        rootcatalog="/backup/output/" #path to store your backups
        dbusername="username"         #grant select on database.*, no adidional permissions! for security ;)
        dbpassword='password'
        daystostore="14"                  #days to store your all your backups, script always leaves one from each day
        authenticationDatabase='admin'
#                                                                                                                                       >########################################################################################################################################>
currentdate="$(date +"%d_%m_%Y")"
outputcatalog=$rootcatalog


cd $rootcatalog
outputcatalog+=$currentdate
outputcatalog+="/"
if [ -d "$outputcatalog" ]
then
echo "Path $outputcatalog$currentdate/ Exists"
else
        echo "Path $outputcatalog$currentdate/ did not exist, creating"
        mkdir $currentdate
fi


echo "Dumping Dababase: $database to: $outputcatalog"
#time=$(date +"%d_%m_%Y_%T") fixed
time=$(date +"%Y_%m_%d_%T")
filename=$database
#filename+="_$time.sql" ---roznica od mysql
filename+="_$time"
path=$outputcatalog
path+=$filename

#mysqldump -u $dbusername -p$dbpassword $database --single-transaction --events --routines --quick --lock-tables=false > $path --roznica od mysql
mongodump -u $dbusername -p $dbpassword --authenticationDatabase=$authenticationDatabase -d $database -o $path

patha=$path
patha+=".tar.gz"
#echo "Komenda kompresji: GZIP=-9 tar cvzf $patha $path"
GZIP=-9 tar cvzf $patha $path
rm -R -f $path

#daytopurge=$(date +%d_%m_%Y -d "$daystostore days ago") #this needs correction?
daytopurge=$(date +%Y_%m_%d -d "$daystostore days ago")
cd $rootcatalog
if [ -d "$rootcatalog/$daytopurge/" ]
        then
                cd $daytopurge
                ls -1tr | head -n -1 | xargs -d '\n' rm -f --
else
        echo "PATH $rootcatalog$daytopurge/ DOESNT EXIST"
fi

