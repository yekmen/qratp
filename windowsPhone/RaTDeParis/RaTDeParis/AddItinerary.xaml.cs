using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Navigation;
using Microsoft.Phone.Controls;
using Microsoft.Phone.Shell;

namespace RaTDeParis
{
    public partial class AddItinerary : PhoneApplicationPage
    {
        public List<Types> types;
        private OfflineData<Models.LineModel> offlinesData;
        private List<Models.DirectionModel> directionsData;
        private List<Models.StationModel> stationsData;

        public class Types {

            public string typeName
            {
                get;
                set;
            }
        }
        public AddItinerary()
        {
            InitializeComponent();

            offlinesData = PhoneApplicationService.Current.State["param"] as OfflineData<Models.LineModel>;
            types = new List<Types>();
            binds();
        }
        void DirectionDataIsReady(object obj)
        {
            directionsData = obj as List<Models.DirectionModel>;
            DirectionList.ItemsSource = directionsData;
            panoramaControl.DefaultItem = panoramaControl.Items[2];
        }
        void SelectionDataIsReady(object obj)
        {
            stationsData = obj as List<Models.StationModel>;
            StationList.ItemsSource = stationsData;
            panoramaControl.DefaultItem = panoramaControl.Items[3];
        }
        public void binds() {
            bindTypes();
        }
        public void bindTypes() {
            types.Add(new Types { typeName = "RER" });
            types.Add(new Types { typeName = "Metro" });
            types.Add(new Types { typeName = "Bus" });
            TypeList.ItemsSource = types;
        }
        public void Type_selection(object sender, SelectionChangedEventArgs e)
        {
            int selection = TypeList.SelectedIndex;
            //String item = types[selection].typeName;
            if (selection == 0) // RER
            {
                LinesList.ItemsSource = offlinesData.getRER();
            }
            else if (selection == 1)    //Métro
            {
                LinesList.ItemsSource = offlinesData.getMetro();
            }
            else if (selection == 2) //Bus
            {
                LinesList.ItemsSource = offlinesData.getBus();
            }

            panoramaControl.DefaultItem = panoramaControl.Items[1];
        }
        public void Line_selection(object sender, SelectionChangedEventArgs e) 
        {
            Models.LineModel selection = LinesList.SelectedItem as Models.LineModel;
            int id = selection.id;
            directionsData = new List<Models.DirectionModel>();
            DataRequest<Models.DirectionModel> g = new DataRequest<Models.DirectionModel>(directionsData, Request_type.Direction, id);
            g.FinTraitement += DirectionDataIsReady;    
        }

        public void Direction_selection(object sender, SelectionChangedEventArgs e)
        {
            Models.DirectionModel directionSelection = DirectionList.SelectedItem as Models.DirectionModel;

            Models.LineModel lineSelection = LinesList.SelectedItem as Models.LineModel;
            int lineID = lineSelection.id;

            int directionID = directionSelection.id;
            
            stationsData = new List<Models.StationModel>();
            DataRequest<Models.StationModel> g = new DataRequest<Models.StationModel>(stationsData, Request_type.Station, lineID, directionID);
            g.FinTraitement += SelectionDataIsReady;
        }
        public void Station_selection(object sender, SelectionChangedEventArgs e) { }
        public void add() {
            MessageBoxResult result = MessageBox.Show("title", "caption", MessageBoxButton.OKCancel);
            if (result == MessageBoxResult.OK)
            {
                MessageBox.Show("yes");
            }
            else {
                MessageBox.Show("no");
            }
        }
    }
}