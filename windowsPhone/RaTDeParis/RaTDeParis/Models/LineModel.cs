using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RaTDeParis.Models
{
    public class LineModel
    {
        public int id
        {
            get;
            set;
        }
        public int type_id
        {
            get;
            set;
        }
        public string type_name
        {
            get;
            set;
        }
        public string line
        {
            get;
            set;
        }
    }
    class LinesModel 
    {
        public List<LineModel> lines
        {
            get;
            set;
        }
    }
}
