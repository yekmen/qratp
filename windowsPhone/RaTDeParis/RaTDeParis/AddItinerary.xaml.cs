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
        public void binds() {
            bindTypes();
        }
        public void bindTypes() {
            types.Add(new Types { typeName = "RER" });
            types.Add(new Types { typeName = "Metro" });
            types.Add(new Types { typeName = "Bus" });
            TypeList.ItemsSource = types;
        }
        public void bindDirections() { 
        
        }
        public void bindStations() { 
        
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
        }
        public void Line_selection(object sender, SelectionChangedEventArgs e) { 
        
        }

        public void Direction_selection(object sender, SelectionChangedEventArgs e) { }
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