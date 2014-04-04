using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RaTDeParis
{
    class JsonRequest
    {
        public int Id { get; set; }
        public string Description { get; set; }
        public double PriceUS { get; set; }
        public DateTime DateOrdered { get; set; }
    }
}
