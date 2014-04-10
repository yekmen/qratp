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
        // Constructeur
        public MainPage()
        {
            InitializeComponent();
            Debug.WriteLine("CHARGEMENT !!!");
<<<<<<< HEAD
            OfflineData of = new OfflineData();
=======
            List<Models.StationModel> lines = new List<Models.StationModel>();
            DataRequest<Models.StationModel> g = new DataRequest<Models.StationModel>(lines, Request_type.Station);

>>>>>>> 25e09cb7c0c0d3e2f465a9752ad058dbb107f7ff
            // Exemple de code pour la localisation d'ApplicationBar
            //BuildLocalizedApplicationBar();
          //  private void hyperlinkButton1_Click(object sender, RoutedEventArgs e)
        //{
        //}
        }
        private void AddClicked_Click(object sender, EventArgs e)
        {
            NavigationService.Navigate(new Uri("/AddItinerary.xaml", UriKind.Relative));
        }
        private void toto(object sender, EventArgs e)
        {
            Debug.WriteLine("Clickeddddd TOTO");
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