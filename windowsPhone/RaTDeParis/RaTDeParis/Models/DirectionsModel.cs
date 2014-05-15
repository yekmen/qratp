using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RaTDeParis.Models
{
    class DirectionModel
    {
        public int id
        {
            get;
            set;
        }
        public string direction
        {
            get;
            set;
        }
    }
    class DirectionsModel
    {
        public List<DirectionModel> directions
        {
            get;
            set;
        }
    }
}
