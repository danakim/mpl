#!/bin/bash
# Small wrapper script around the mpc command line clien to make use of MPD's last.fm stream loading capabilities.
# It makes loading playlists from last.fm streams easier into MPD, as the default mpc syntax for that is a ugly.
# Author: Dan Achim (dan@hostatic.ro)

# Let's check if we are running the proper MPD version. The syntax in this script will only work with versions 0.16.x and above
MPC_VER=$(mpc version | awk {'print $3'} | cut -d '.' -f 2)
if [[ $MPC_VER -lt 16 ]]; then echo -e "This script only works for MPD versions 0.16.x or above.\n" ; exit 2 ; fi

# Check if the third argument is the number of tracks multiplier and if not given, default it to 5
if [[ $3 = *[[:digit:]]* ]]; then
    NO=$3
else
    NO=$4
fi
: ${NO:="5"}

help_function() { echo -e "
    Usage: mpl [option] [data] {optional_info} {number of tracks}\n
    option (mandatory) is one of: u|user
                                  a|artist
                                  g|genre
                                  ut|usertags
                                  gt|globaltags\n
    data (mandatory) depends on the above given option and is one of: lastfm_username, artist_name, genre, lastfm_globaltag, lastfm_usertag\n
    optional_info (optional) is additional data given to further filter the above search and is one of:
                                  for lastfm_username: loved, personal, recommended, playlist
                                  for lastfm_usertags: tag
                                  for lastfm_globaltags: tag
                                  for artist_name: similarartist, fans\n
    number_of_tracks (optional): the MPD last.fm plugin loads only 5 tracks by default for each call. If you want to load more tracks, supply
                                 a number as the last argument and it will multiply this by 5, thus loading 5 x n tracks. If you don't specify
                                 this number by default it will load 25 tracks.\n
    "
    exit 1
}

# This is the main function that does all the work. Gets the arguments from the case statements below.
load_function() {
    if [ -z "$2" ]; then help_function ; fi
    echo -n "Loading $((5*NO)) tracks from: "
    for i in `seq $NO`; do
        if ( [[ $3 && $3 = *[[:digit:]]* ]] || [[ -z $3 ]] ); then
            mpc load "lastfm://$1/$2" > /tmp/.mpl 2>&1
        else
            mpc load "lastfm://$1/$2/$3" > /tmp/.mpl 2>&1
        fi
    done
    if [[ $? -eq 0 ]]; then
        cat /tmp/.mpl | awk {'print $2'} | sed s#lastfm\://## | sed s#/#\ #g && rm -rf /tmp/.mpl
    else
        echo -ne "\nCouldn't load tracks: " ; cat /tmp/.mpl && rm -rf /tmp/.mpl ; exit 4
    fi
}

case $1 in
    a|artist)
        load_function artist $2 $3
        ;;
    u|user)
        load_function user $2 $3
        ;;
    ut|usertags)
        load_function usertag $2 $3
        ;;
    gt|globaltags)
        load_function globaltag $2 $3
        ;;
    g|genre)
        load_function genre $2 $3
        ;;
    *)
        help_function
        ;;
esac
