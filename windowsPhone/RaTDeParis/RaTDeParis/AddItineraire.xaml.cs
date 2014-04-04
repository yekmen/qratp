using System;
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
    public class StationsModel
    {
        public List<StationModel> stations{ get; set; }
    }
    public class StationModel
    {
        public string station{ get; set; }
        public int id { get; set; }
    }
    public partial class Page1 : PhoneApplicationPage
    {
        private WebClient webClient;
        private StationsModel stations;

        public Page1()
        {
            InitializeComponent();
            DownloadJSON_Data();
        }
        private void DownloadJSON_Data()
        {
            webClient = new System.Net.WebClient();
            webClient.DownloadStringCompleted += new DownloadStringCompletedEventHandler(loadHTMLCallback);
            webClient.DownloadStringAsync(new Uri("http://metro.breizh.im/dev/ratp_api.php?action=getStationList&line=1157&direction=80649"));
        }
        public void loadHTMLCallback(Object sender, DownloadStringCompletedEventArgs e)
        {
            string textData = e.Result;

            // Now parse with JSON.
            StationModel model = Newtonsoft.Json.JsonConvert.DeserializeObject<StationModel>(textData);
            // JsonConvert.DeserializeObject<Movie>(json)
            stations = Newtonsoft.Json.JsonConvert.DeserializeObject<StationsModel>(textData);
  
            StationsList.ItemsSource = stations.stations;
        }
    }
}