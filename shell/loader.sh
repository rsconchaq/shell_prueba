#/!bin/ksh

#########################################################################
### Objetivo del shell				: 	implementar carga sqlloader
### Nombre del shell				:	loader.sh
###	Descripcion del proceso			:	shell implementa sqlloader
### Analista creador				:	reynaldo
###	Fecha creacion					:	31/01/2017
#########################################################################

HOME=/home/T11645/sqlloader;
. $HOME/bin/.varset
. $HOME/bin/.passet

SCRIPT_NAME=loader
SELF_LOG=log_trace

pMessage()
{
   LOGDATE=`date +"%d-%m-%Y %H:%M:%S"`
   echo "($LOGDATE) $*"
   echo "($LOGDATE) $*"  >> ${DIR_LOG}/$SELF_LOG.log
}

HORA=`date +"%d-%m-%Y %H:%M:%S"`
USUARIO=`whoami`
HOST=`hostname`
IP_ORIGEN=`cat /etc/hosts | grep -v '#' | grep ${HOST} | awk '{print $1}'`
pMessage "**********************************************************"
pMessage "Iniciando proceso"
pMessage "Fecha y Hora		:	${HORA}"
pMessage "Usuario			:	${USUARIO}"
pMessage "Shell			:	${SCRIPT_NAME}.sh"
pMessage "Ip 			: 	${IP_ORIGEN}"
pMessage "Host 			: 	${HOST}"
pMessage "**********************************************************"$'\n'

pMessage "Comprobando existencia del fichero..."
if [ -s ${DIR_INPUT}/${SCRIPT_NAME}.dat ]
then
	pMessage "El fichero de datos existe, se procede a efectuar la carga."
elif [ -a ${DIR_INPUT}/${SCRIPT_NAME}.dat ]
then
	pMessage "El fichero existe pero no contiene datos."
	pMessage "Se procede a termianar el proceso."
	exit
else
	pMessage "El fichero de datos a cargar no existe."
	pMessage "Se procede a termianar el proceso."
	exit
fi
pMessage "Fin de comporbacion de fichero"$'\n'

pMessage "Inicio del proceso sql loader..."
(sqlldr ${USRMSSAP}/${PASSMSSAP}@${BDMSSAP} control=${DIR_CTL}/${SCRIPT_NAME}.ctl data=${DIR_INPUT}/${SCRIPT_NAME}.dat log=${DIR_LOG}/${SCRIPT_NAME}.log bad=${DIR_BAD}/${SCRIPT_NAME}.bad errors=10000000) >> $DIR_LOG/$SELF_LOG.log
pMessage ""
pMessage "Fin del proceso sql loader"
pMessage "Favor de revisar los logs de carga"$'\n'