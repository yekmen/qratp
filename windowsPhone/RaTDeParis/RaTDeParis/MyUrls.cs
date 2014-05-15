using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RaTDeParis
{
    class MyUrls
    {
        public static string getLine()
        {
            return "http://metro.breizh.im/dev/ratp_api.php?action=getLineList";
        }
        public static string getDirections(int line)
        {
            return "http://metro.breizh.im/dev/ratp_api.php?action=getDirectionList&line="+line;
        }
        public static string getStations(int line, int direction)
        {
            return "http://metro.breizh.im/dev/ratp_api.php?action=getStationList&line="+line+"&direction="+direction;
        }
        public static string getSchedule(int line, int direction, int station)
        {
            return "http://metro.breizh.im/dev/ratp_api.php?action=getSchedule&line="+line+"&direction="+direction+"&station="+station;
        }
    }
   
}
