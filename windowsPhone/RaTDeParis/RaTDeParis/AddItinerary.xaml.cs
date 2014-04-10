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
        public void bindLines() { 
        
        }
        public void bindDirections() { 
        
        }
        public void bindStations() { 
        
        }
        public void Type_selection(object sender, SelectionChangedEventArgs e)
        {
            int selection = TypeList.SelectedIndex;
            String item = types[selection].typeName;
            add();
        }
        public void Line_selection(object sender, SelectionChangedEventArgs e) { }

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