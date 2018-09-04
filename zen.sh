#!/bin/sh
# emile@guntari.com

now=`date +%s`

# shortest and longest wait time between bells
intervalMin=90
intervalMax=180

#################
### FUNCTIONS ###
#################

# write time of next bell to /tmp/zen
setGongTime()
{
    # creata a random value between min and max.
    min=$(($intervalMin * 60 * 1000))
    max=$(($intervalMax * 60 * 1000))
    rand=`awk -vmin=$min -vmax=$max 'BEGIN{srand();print int(rand()*(max-min))+min}'`
    #Timeout=$(($rand / 60000))
    Timeout=$(( $(($rand / 60000))*60 ))
    #gongTime=$(($now+$Timeout))
    gongTime=$(($now+$Timeout))
    echo $gongTime > /tmp/zen
    echo $gongTime >> /home/kapu/log/zen.log
}

playRandomSound()
{
    echo started function
# Get list of files in RANDOM_BELL_SCRIPT_BELLS into a \a delimited string bell_list
bell_list=`find /home/kapu/mySounds/zen/RANDOM_BELL_SCRIPT_BELLS -type f | tr '\n' '\a'`

awk -v bell_list="$bell_list" -f - <<EOF
    BEGIN{
        n=split(bell_list, bell, "\a")
        srand()
        chickenDinner=bell[int(1+rand()*(n-2))]
        vol=100
         (chickenDinner ~ /116315__garuda1982__big-singing-bowl.wav/)? vol=150 : x=x
         (chickenDinner ~ /122647__juskiddink__singing-bowl-2.wav/)? vol=120 : x=x
         (chickenDinner ~ /127167__daphne-in-wonderland__tibetan-ball.wav/)? vol=120 : x=x
         (chickenDinner ~ /390201__ganapataye__02-bells.aiff/)? vol=930 : x=x
         (chickenDinner ~ /400819__enhuber__singing-bowl.wav/)? vol=530 : x=x
         (chickenDinner ~ /415141__s-light__singing-bowl-single-strike-6.wav/)? vol=130 : x=x
         (chickenDinner ~ /432568__vortichez__gong-tibetan-buddhist-temple-ulaanbaatar-mongolia_EDIT_000.wav/)? vol=1000 : x=x
         (chickenDinner ~ /47665__arnaud-coutancier__tibetan-bowl-bol-tibet-attac.wav/)? vol=130 : x=x
         (chickenDinner ~ /48795__itsallhappening__bell-inside.wav/)? vol=330 : x=x
         (chickenDinner ~ /48796__itsallhappening__bell-outside.wav/)? vol=230 : x=x
         (chickenDinner ~ /80578__benboncan__nepalese-singing-bowl.wav/)? vol=90 : x=x
         (chickenDinner ~ /Bell635-PqK5umGu0hE.wav/)? vol=100 : x=x
         (chickenDinner ~ /PlumVillage.wav/)? vol=130 : x=x
         (chickenDinner ~ /PlumVillage_bell.000.wav/)? vol=130 : x=x
         (chickenDinner ~ /PlumVillage_bell.001.wav/)? vol=130 : x=x
         (chickenDinner ~ /PlumVillage_bell_withSmallHitAtEnd.000.wav/)? vol=140 : x=x
         (chickenDinner ~ /ShantidevaCenter.wav/)? vol=120 : x=x
         (chickenDinner ~ /bowl.ogg/)? vol=120 : x=x
         (chickenDinner ~ /end_daikei.wav/)? vol=110 : x=x
         (chickenDinner ~ /end_hatto_bell.wav/)? vol=100 : x=x
         (chickenDinner ~ /end_sodo_bell.wav/)? vol=100 : x=x
         (chickenDinner ~ /zen_flesh_zen_bones.wav/)? vol=800 : x=x
        printf("Playing %s at volume %d\n", chickenDinner, vol)
        system("mplayer -softvol -volume " vol " " chickenDinner )
    }
EOF
    echo shell function exit
}

fireUp()
{  
   currenttime=$(date +%H:%M)
   if [[ "$currenttime" > "23:00" ]] || [[ "$currenttime" < "06:30" ]] ; then
     exit
   elif [ -e /tmp/zazen_is_running ]; then
       exit
   else
     #/home/kapu/bin/maybe mplayer -softvol -volume 40 /home/kapu/mySounds/zen/bowl.ogg
     #/home/kapu/bin/maybe mplayer -softvol -volume 40 /home/kapu/mySounds/zen/ShantidevaCenter.wav
     #/home/kapu/bin/maybe mplayer -softvol -volume 100 /home/kapu/mySounds/zen/ShantidevaCenter.wav
     playRandomSound
   fi
}


#playRandomSound
#exit 1

# Do we have a time to Gong?
if [ -f /tmp/zen ]
then
# /tmp/zen exists!
# read integer from /tmp/zen
    gongTime=$(cat /tmp/zen)
else
    setGongTime
    exit
fi

if [ $gongTime -le $now ]
then
  fireUp
  rm /tmp/zen
  exit
else
  echo Gong in $(($gongTime - $now)) seconds
fi


