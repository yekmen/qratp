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
    class OfflineData<T>
    {
        public IsolatedStorageSettings isolatedStore = IsolatedStorageSettings.ApplicationSettings;
        private enum LineType{
            Bus = 1,
            Metro = 2,
            Tram = 6,
            RER = 4
        }
        public OfflineData(List<T> list, Request_type type)
        {
            
            if (isolatedStore.Contains("lineData"))  
            {
                isolatedStore["lineData"] = list;       // lineData is existe
            }
            else
            {
                Debug.WriteLine("Data base not exists");
                isolatedStore.Add("lineData", list);
            }
            isolatedStore.Save();
            /*
            Debug.WriteLine("Size : " + isolatedStore.Count());
            isolatedStore.Clear();
            Debug.WriteLine("Size : " + isolatedStore.Count());
            
            foreach(var element in list)
            {
                if (element is Models.LineModel)
                {
                    Data _data = new Data((element as Models.LineModel).id,
                                          (element as Models.LineModel).line,
                                          (element as Models.LineModel).type_id,
                                          (element as Models.LineModel).type_name);
                    if(_data.Line == "")
                        Debug.WriteLine("Line is empty" + _data.Line);
                    else if(isolatedStore.Contains(_data.Line))
                        Debug.WriteLine("Line is already exists" + _data.Line);
                    else
                    {
                        Debug.WriteLine("Try to save : " + _data.Line);
                        Debug.WriteLine("Size : " + isolatedStore.Count());
                        isolatedStore.Add(_data.Line, _data);
                    }
                }
            }

            isolatedStore.Save();
            */
            List<Models.LineModel> ret = getLine();
            Debug.WriteLine("Size : " + ret.Count());
            Debug.WriteLine("Bus size : " + getBus().Count());
            Debug.WriteLine("Metro size : " + getMetro().Count());
            Debug.WriteLine("RER size : " + getRER().Count());
            Debug.WriteLine("Tram size : " + getTRAM().Count());
        }
        public List<Models.LineModel> getLine()
        {
            Object temp;
            if (!loadObject("lineData", out temp))
                Debug.WriteLine("LineData not exists !!!");
            return temp as List<Models.LineModel>;
        }
        public List<Models.LineModel> getBus()      //type_id = 1 for BUS 
        {
            return getData(LineType.Bus);
        }
        public List<Models.LineModel> getMetro()
        {
            return getData(LineType.Metro);
        }
        public List<Models.LineModel> getRER()
        {
            return getData(LineType.RER);
        }
        public List<Models.LineModel> getTRAM()
        {
            return getData(LineType.Tram);
        }
        private List<Models.LineModel> getData(LineType type)
        {
            List<Models.LineModel> lines = getLine();       //Get all line before parsing
            List<Models.LineModel> ret = new List<Models.LineModel>();      // returned list
            for (int i = 0; i < lines.Count(); i++)
            {
                if (lines[i].type_id == (int)type)
                    ret.Add(lines[i]);
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
