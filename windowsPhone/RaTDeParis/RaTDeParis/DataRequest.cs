﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Navigation;
using Microsoft.Phone.Controls;
using Microsoft.Phone.Shell;
using System.Diagnostics;
using Microsoft.Phone.Storage;

using System.Xml;
using Newtonsoft.Json.Converters;
using Newtonsoft.Json.Linq;
using Newtonsoft.Json.Serialization;
using Newtonsoft.Json.Utilities;
using Windows.Storage;
using System.Threading.Tasks;
using System.IO.IsolatedStorage; 
namespace RaTDeParis
{
    public enum Request_type
    {
        Direction,
        Line,
        Station,
        Schedule
    };
    class DataRequest<T>
    {

        private Request_type currentType;
        private WebClient webClient;
        private List<T> list;
        private string mUrl;    

        public DataRequest(List<T> list, Request_type type)
        {
           this.list = list;
           Download(type);
        }
        public DataRequest(List<T> list, string _URL, Request_type type)
        {
            this.list = list;
            this.mUrl = _URL;
            Download(type);
        }
        private void Download(Request_type type) {
            currentType = type;
            switch (type) { 
                case Request_type.Direction:
                    break;
                case Request_type.Line:
                    DownloadJSON_Data(MyUrls.getLine());
                    break;
                case Request_type.Station:
                    DownloadJSON_Data(MyUrls.getStations(1151, 80649));
                    break;
                case Request_type.Schedule:
                    DownloadJSON_Data(mUrl);
                    break;
            }
        }
        private void DownloadJSON_Data(string url)
        {
            webClient = new System.Net.WebClient();
            webClient.DownloadStringCompleted += new DownloadStringCompletedEventHandler(loadHTMLCallback);
            webClient.DownloadStringAsync(new Uri(url));
        }
        public void loadHTMLCallback(Object sender, DownloadStringCompletedEventArgs e)
        {
            try
            {
                string textData = e.Result;
                switch (currentType)
                {
                    case Request_type.Direction:
                        Models.DirectionsModel model = Newtonsoft.Json.JsonConvert.DeserializeObject<Models.DirectionsModel>(textData);
                        break;
                    case Request_type.Line:
                        Models.LinesModel model2 = Newtonsoft.Json.JsonConvert.DeserializeObject<Models.LinesModel>(textData);
                        list = model2.lines as List<T>;
                        break;
                    case Request_type.Station:
                        Models.StationsModel model3 = Newtonsoft.Json.JsonConvert.DeserializeObject<Models.StationsModel>(textData);
                        list = model3.stations as List<T>;
                        break;
                    case Request_type.Schedule:
                        Models.ScheduleModel model4 = Newtonsoft.Json.JsonConvert.DeserializeObject<Models.ScheduleModel>(textData);
                        list = model4.schedule as List<T>;
                        break;
                }
                if (FinTraitement != null)
                    FinTraitement(list);
            }
            catch
            {
                Debug.WriteLine("No internet connection or server not response !");
                MessageBoxResult result = MessageBox.Show("Warning", "No internet connection ... ", MessageBoxButton.OK);
            }
           
        }

        public event Action<object> FinTraitement;
    }
}
