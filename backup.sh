#/bin/bash
################################################## CONFIGURATION ##########################################################################
#																	#|
	database="nameofdatabase"                                           
	rootcatalog="/backup/destenation/" #path to store your backups
	dbusername="mysqlusername"         #grant select on database.*, no adidional permissions! for security ;)
	dbpassword="yoursecretpassword"
	daystostore="14"                  #days to store your all your backups, script always leaves one from each day
#																	#|
##########################################################################################################################################

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
time=$(date +"%d_%m_%Y_%T")
filename=$database
filename+="_$time.sql"
path=$outputcatalog
path+=$filename

mysqldump -u $dbusername -p$dbpassword $database --single-transaction --events --routines --quick --lock-tables=false > $path

patha=$path
patha+=".tar.gz"
#echo "Komenda kompresji: GZIP=-9 tar cvzf $patha $path"
GZIP=-9 tar cvzf $patha $path
rm -f $path

daytopurge=$(date +%d_%m_%Y -d "$daystostore days ago")

cd $rootcatalog
if [ -d "$rootcatalog/$daytopurge/" ]
	then
		cd $daytopurge
		ls -1tr | head -n -1 | xargs -d '\n' rm -f --
else
    	echo "PATH $rootcatalog$daytopurge/ DOESNT EXIST"
fi

