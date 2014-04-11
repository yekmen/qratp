using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Navigation;
using Microsoft.Phone.Controls;
using Microsoft.Phone.Shell;
using RaTDeParis.Resources;
using System.Diagnostics;


namespace RaTDeParis
{
    public partial class MainPage : PhoneApplicationPage
    {
        private List<Models.LineModel> lines;
        private OfflineData<Models.LineModel> offlinesData;
        // Constructeur
        public MainPage()
        {
            InitializeComponent();
            
            lines = new List<Models.LineModel>();
            DataRequest<Models.LineModel> g = new DataRequest<Models.LineModel>(lines, Request_type.Line);
            g.FinTraitement += g_FinTraitement;

        }

        void g_FinTraitement(object obj)
        {
            lines = obj as List<Models.LineModel>;
            offlinesData = new OfflineData<Models.LineModel>(lines, Request_type.Line);
        }
        private void showItineraries()
        {
            if (offlinesData != null)
            {
                ItinerariesList.ItemsSource = offlinesData.getItineraries();
            }
        }
        private void AddClicked_Click(object sender, EventArgs e)
        {
            NavigationService.Navigate(new Uri("/AddItinerary.xaml", UriKind.Relative));
        }
        private void toto(object sender, EventArgs e)
        {
            Debug.WriteLine("Clickeddddd TOTO");
            SaveData tmp = new SaveData("http://metro.breizh.im/dev/ratp_api.php?action=getSchedule&line=1151&direction=80649&station=30783","76", SaveData.Sens.Aller);
            offlinesData.saveItinerary("prrt", tmp);
        }
        // Exemple de code pour la conception d'une ApplicationBar localisée
        //private void BuildLocalizedApplicationBar()
        //{
        //    // Définit l'ApplicationBar de la page sur une nouvelle instance d'ApplicationBar.
        //    ApplicationBar = new ApplicationBar();

        //    // Crée un bouton et définit la valeur du texte sur la chaîne localisée issue d'AppResources.
        //    ApplicationBarIconButton appBarButton = new ApplicationBarIconButton(new Uri("/Assets/AppBar/appbar.add.rest.png", UriKind.Relative));
        //    appBarButton.Text = AppResources.AppBarButtonText;
        //    ApplicationBar.Buttons.Add(appBarButton);

        //    // Crée un nouvel élément de menu avec la chaîne localisée d'AppResources.
        //    ApplicationBarMenuItem appBarMenuItem = new ApplicationBarMenuItem(AppResources.AppBarMenuItemText);
        //    ApplicationBar.MenuItems.Add(appBarMenuItem);
        //}
    }
}