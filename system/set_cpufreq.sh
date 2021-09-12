#! /bin/bash

min_freq=`cat /sys/devices/system/cpu/cpufreq/policy0/cpuinfo_min_freq`
max_freq=`cat /sys/devices/system/cpu/cpufreq/policy0/cpuinfo_max_freq`
powersave_freq=$[ $max_freq * 2 / 3 ] # Defaults to circa 67% of max

# Check for user input
if [ $# -eq 1 ]
then
    request=$1
else
    request=$powersave_freq
fi

# Handle presets
case $1 in
    min)
        request=$min_freq
        ;;
    max)
        request=$max_freq
        ;;
    powersave)
        request=$powersave_freq
        ;;
esac
    
# Check for lower bound
if [[ $request -lt $min_freq ]]
then
    echo Request too low. Minimum available: $min_freq
    request=$min_freq
fi

# Check for upper bound
if [[ $request -gt $max_freq ]]
then
    echo Request too high. Maximum available: $max_freq
    request=$max_freq
fi

echo Setting scaling_max_freq to $request

for f in /sys/devices/system/cpu/cpufreq/*/scaling_max_freq
do
    sudo sh -c "echo $request > $f"
done

