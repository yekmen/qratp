using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO.IsolatedStorage;
using System.Diagnostics;
using System.Runtime.Serialization;

namespace RaTDeParis
{
    [DataContract]
    public class Data
    {
        [DataMember]
        public int ID { get; set; }
        [DataMember]
        public string Line { get; set; }
        [DataMember]
        public int Type_ID { get; set; }
        [DataMember]
        public string Type_Name { get; set; }
        
        public Data(int _ID, string _Line, int _TypeID, string _TypeName)
        {
            ID = _ID;
            Line = _Line;
            Type_Name = _TypeName;
            Type_ID = _TypeID;
        }
    }
    class OfflineData
    {
        public IsolatedStorageSettings isolatedStore = IsolatedStorageSettings.ApplicationSettings;
        
        public OfflineData()
        {
            isolatedStore.Remove("userData");
            Data _data = new Data(1, "test", 2, "test2");
            isolatedStore.Add("userData", _data);
            isolatedStore.Save();

            List<Data> ret = getBus();
            Debug.WriteLine("Size : " + ret.Count());
        }
        public List<Data> getBus()
        {
            List<Data> ret = new List<Data>(); //returned value
            
            for(int i = 0; i < isolatedStore.Count(); i++)
            {
                Object temp;
                if (loadObject("userData", out temp))
                {
                    Data _data = (Data)temp;
                    ret.Add(_data);
                }
            }
            return ret;
        }
        private bool loadObject(string keyname, out object result)
        {
            result = null;
            try
            {
                result = isolatedStore[keyname];
            }
            catch
            {
                return false;
            }
            return true;
        }
    }
}
