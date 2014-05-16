using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RaTDeParis.Models
{
    class StationModel
    {
        public int id
        {
            get;
            set;
        }
        public string station
        {
            get;
            set;
        }
    }
    class StationsModel
    {
        public List<StationModel> stations
        {
            get;
            set;
        }
    }
}
