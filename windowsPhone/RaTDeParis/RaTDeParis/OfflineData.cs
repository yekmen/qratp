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
    [DataContract]
    public class SaveData
    {
        public enum Sens
        {
            Aller,
            Retour
        }
        [DataMember]
        private string Url { get; set; }
        [DataMember]
        private string LineName { get; set; }
        [DataMember]
        private Sens Way { get; set; }    //Aller ou Retour

        public SaveData(string _URL, string _LineName, Sens _Way)
        {
            Url = _URL;
            LineName = _LineName;
            Way = _Way;
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
        public Models.LineModel getLineNameByID(int _id)        //return null if line id not found
        {
            Models.LineModel ret = null;
            List<Models.LineModel> lines = getLine();       //Get all line before parsing
            for (int i = 0; i < lines.Count(); i++)
            {
                if (lines[i].type_id == _id)
                {
                    ret = lines[i];
                    Debug.WriteLine("ID : " + _id + " = " + ret.line);
                }
                else
                {
                    Debug.WriteLine("This " + _id + " not found !, return NULL !");
                    ret = null;
                }
            }

            return ret; 
        }
        public void saveItinerary(string itineraryName, SaveData _saveData)
        {
            if (isolatedStore.Contains(itineraryName))    //Is exists
            {
                List<SaveData> currentItineraries = getItineraries(itineraryName);
                currentItineraries.Add(_saveData);
                isolatedStore.Add(itineraryName, currentItineraries);
            }
            else
            {
                List<SaveData> currentItineraries = new List<SaveData>();
                currentItineraries.Add(_saveData);
                isolatedStore.Add(itineraryName, currentItineraries);
                Debug.WriteLine("Itinerary not exists");
            }

            isolatedStore.Add("__itiner@ry", itineraryName);
            isolatedStore.Save();
        }
        public List<SaveData> getItineraries(string itineraryName)
        {
            Object temp;
            if (!loadObject(itineraryName, out temp))
                Debug.WriteLine("Itineraries not exists !!!");
            return temp as List<SaveData>;
        }
        public List<SaveData> getItineraries()  //List of itineraries name
        {
            Object temp;
            if (!loadObject("__itiner@ry", out temp))
                Debug.WriteLine("Itineraries not exists !!!");
            return temp as List<SaveData>;
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
