#!/bin/sh
# emile at guntari dotcom

now=`date +%s`
allBells=
nowDammit=
seconds=

usage() {
  cat << EOF >&2
Usage: $PROGNAME [-a <play all bells>] [-n <play it now>] [-s <seconds to wait>]

EOF
  exit 1
}
while getopts ans: OPTION; do
  case $OPTION in
    (a) allBells=1;;
    (n) NowDammit=1;;
    (s) seconds=$OPTARG;;
    (*) usage
  esac
done
shift "$((OPTIND - 1))"

if [ "x" != "x$seconds" ];then
    isInt=`awk -v s=$seconds 'BEGIN{ if ( s !~ /^[0-9]+$/) print 1 }'`
    if [ "$isInt" == "1" ];then
      echo s must be an integer
      exit 1
    fi
    echo we have a manual seconds entry of $seconds
fi

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
# Get list of files in RANDOM_BELL_SCRIPT_BELLS into a \a delimited string bell_list
bell_list=`find /home/kapu/mySounds/zen/RANDOM_BELL_SCRIPT_BELLS -type f | tr '\n' '\a'`

awk -v bell_list="$bell_list" -f - <<EOF
    BEGIN{
        n=split(bell_list, bell, "\a")
        srand()
        chickenDinner=bell[int(1+rand()*(n-2))]
        vol=100
         if (chickenDinner ~ /116315__garuda1982__big-singing-bowl.wav/) vol=150
         if (chickenDinner ~ /122647__juskiddink__singing-bowl-2.wav/) vol=120
         if (chickenDinner ~ /127167__daphne-in-wonderland__tibetan-ball.wav/) vol=120
         if (chickenDinner ~ /390201__ganapataye__02-bells.aiff/) vol=930
         if (chickenDinner ~ /400819__enhuber__singing-bowl.wav/) vol=230
         if (chickenDinner ~ /415141__s-light__singing-bowl-single-strike-6.wav/) vol=130
         if (chickenDinner ~ /432568__vortichez__gong-tibetan-buddhist-temple-ulaanbaatar-mongolia_EDIT_000.wav/) vol=1000
         if (chickenDinner ~ /47665__arnaud-coutancier__tibetan-bowl-bol-tibet-attac.wav/) vol=130
         if (chickenDinner ~ /48795__itsallhappening__bell-inside.wav/) vol=330
         if (chickenDinner ~ /48796__itsallhappening__bell-outside.wav/) vol=230
         if (chickenDinner ~ /80578__benboncan__nepalese-singing-bowl.wav/) vol=90
         if (chickenDinner ~ /Bell635-PqK5umGu0hE.wav/) vol=100
         if (chickenDinner ~ /PlumVillage.wav/) vol=130
         if (chickenDinner ~ /PlumVillage_bell.000.wav/) vol=130
         if (chickenDinner ~ /PlumVillage_bell.001.wav/) vol=130
         if (chickenDinner ~ /PlumVillage_bell_withSmallHitAtEnd.000.wav/) vol=140
         if (chickenDinner ~ /ShantidevaCenter.wav/) vol=120
         if (chickenDinner ~ /bowl.ogg/) vol=120
         if (chickenDinner ~ /end_daikei.wav/) vol=110
         if (chickenDinner ~ /end_hatto_bell.wav/) vol=100
         if (chickenDinner ~ /end_sodo_bell.wav/) vol=100
         if (chickenDinner ~ /zen_flesh_zen_bones.wav/) vol=700
         if (chickenDinner ~ /42095__fauxpress__bell-meditation/) vol=130
         if (chickenDinner ~ /230 27421__kerri__zenbell-1/) vol=230
         if (chickenDinner ~ /zen_flesh_zen_bones_X2/) vol=700
        printf("%s VOLUME:%d\n", chickenDinner, vol)
        system("mplayer -softvol -volume " vol " " chickenDinner )
    }
EOF
}

playAll()
{
# Get list of files in RANDOM_BELL_SCRIPT_BELLS into a \a delimited string bell_list
bell_list=`find /home/kapu/mySounds/zen/RANDOM_BELL_SCRIPT_BELLS -type f | tr '\n' '\a'`

awk -v bell_list="$bell_list" -f - <<EOF
    BEGIN{
        n=split(bell_list, bell, "\a")
        for(i in bell){
            vol=100
            if (bell[i] ~ /116315__garuda1982__big-singing-bowl.wav/) vol=150
            if (bell[i] ~ /122647__juskiddink__singing-bowl-2.wav/) vol=120
            if (bell[i] ~ /127167__daphne-in-wonderland__tibetan-ball.wav/) vol=120
            if (bell[i] ~ /390201__ganapataye__02-bells.aiff/) vol=930
            if (bell[i] ~ /400819__enhuber__singing-bowl.wav/) vol=230
            if (bell[i] ~ /415141__s-light__singing-bowl-single-strike-6.wav/) vol=130
            if (bell[i] ~ /432568__vortichez__gong-tibetan-buddhist-temple-ulaanbaatar-mongolia_EDIT_000.wav/) vol=1000
            if (bell[i] ~ /47665__arnaud-coutancier__tibetan-bowl-bol-tibet-attac.wav/) vol=130
            if (bell[i] ~ /48795__itsallhappening__bell-inside.wav/) vol=330
            if (bell[i] ~ /48796__itsallhappening__bell-outside.wav/) vol=230
            if (bell[i] ~ /80578__benboncan__nepalese-singing-bowl.wav/) vol=90
            if (bell[i] ~ /Bell635-PqK5umGu0hE.wav/) vol=100
            if (bell[i] ~ /PlumVillage.wav/) vol=130
            if (bell[i] ~ /PlumVillage_bell.000.wav/) vol=130
            if (bell[i] ~ /PlumVillage_bell.001.wav/) vol=130
            if (bell[i] ~ /PlumVillage_bell_withSmallHitAtEnd.000.wav/) vol=140
            if (bell[i] ~ /ShantidevaCenter.wav/) vol=120
            if (bell[i] ~ /bowl.ogg/) vol=120
            if (bell[i] ~ /end_daikei.wav/) vol=110
            if (bell[i] ~ /end_hatto_bell.wav/) vol=100
            if (bell[i] ~ /end_sodo_bell.wav/) vol=100
            if (bell[i] ~ /zen_flesh_zen_bones.wav/) vol=700
            if (bell[i] ~ /42095__fauxpress__bell-meditation/) vol=130
            if (bell[i] ~ /230 27421__kerri__zenbell-1/) vol=230
            if (bell[i] ~ /zen_flesh_zen_bones_X2/) vol=700
            printf("%s VOLUME:%d\n", bell[i], vol)
            system("mplayer -softvol -volume " vol " " bell[i])
        }
    }
EOF
}

fireUp()
{  
   currenttime=$(date +%H:%M)
   if [[ "$currenttime" > "23:00" ]] || [[ "$currenttime" < "06:30" ]] ; then
     exit
   elif [ -e /tmp/zazen_is_running ]; then
       exit
   else
     playRandomSound
   fi
}


if [ "x" != "x$seconds" ];then
    gongTime=`expr $now + $seconds`
    echo $gongTime > /tmp/zen
    echo MANUAL $seconds >> /home/kapu/log/zen.log
elif [ -f /tmp/zen ];then
    gongTime=$(cat /tmp/zen)
else
    setGongTime
    exit
fi

if [ "x" != "x$NowDammit" ]; then
  playRandomSound
  exit 0
elif [ "x" != "x$allBells" ]; then
  playAll
  rm /tmp/zen
  exit 0
elif [ $gongTime -le $now ]; then
  fireUp
  rm /tmp/zen
  exit 0
else
  echo Gong in $(($gongTime - $now)) seconds
fi

