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
using Coding4Fun.Toolkit.Controls;
namespace RaTDeParis
{
    public partial class MainPage : PhoneApplicationPage
    {
        private List<Models.LineModel> lines;
        private OfflineData<Models.LineModel> offlinesData;
        private string currentItinineraryName;
        private SaveData.Sens currentWay;

        // Constructeur
        public MainPage()
        {
            
            InitializeComponent();
            currentWay = SaveData.Sens.Aller;     //init
            lines = new List<Models.LineModel>();
            DataRequest<Models.LineModel> g = new DataRequest<Models.LineModel>(lines, Request_type.Line);
            g.FinTraitement += g_FinTraitement;
        }

        void g_FinTraitement(object obj)
        {
            lines = obj as List<Models.LineModel>;
            offlinesData = new OfflineData<Models.LineModel>(lines, Request_type.Line);
            fillItineraryList();
        }
        void scheduleDownloaded(object obj)
        {
            //ItinerariesList.ItemsSource = obj as List<string>;
            //ItinerariesList.DataContext = obj as List<string>;
            ItinerariesList.Items.Add("----------------------------");
            foreach(string str in obj as List<string>)
            {
                ItinerariesList.Items.Add(str);
            }
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
            PhoneApplicationService.Current.State["param"] = offlinesData;
            PhoneApplicationService.Current.State["ItName"] = currentItinineraryName;
            PhoneApplicationService.Current.State["Way"] = currentWay;
            
            NavigationService.Navigate(new Uri("/AddItinerary.xaml", UriKind.Relative));
        }
        private void toto(object sender, EventArgs e)
        {
            Debug.WriteLine("Clickeddddd TOTO");
            SaveData tmp = new SaveData("http://metro.breizh.im/dev/ratp_api.php?action=getSchedule&line=1151&direction=80649&station=30783","76", SaveData.Sens.Aller);
            offlinesData.saveItinerary("prrt2", tmp);
            fillItineraryList();
        }
        private void fillItineraryList()
        {
            lpkItineraries.ItemsSource = offlinesData.getItineraries();
        }
        private void lpkItineraries_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            //ListPickerItem lpi = (sender as ListPicker).SelectedItem as ListPickerItem;
            //MessageBox.Show("selected item is : " + lpi.Content);
            
            if (lpkItineraries.SelectedIndex == -1) //otherwise (listPicker1.SelectedItem == null) also works
                return;
            currentItinineraryName = lpkItineraries.SelectedItem.ToString();
            ItinerariesList.Items.Clear();
            List<SaveData> list = offlinesData.getItineraries(currentItinineraryName);
            List<string> schedules = new List<string>();
            for (int i = 0; i < list.Count; i++)
            {
                //DataRequest<Models.ScheduleModel> g = new DataRequest<Models.ScheduleModel>(schedules, list[i].Url, Request_type.Schedule);
                DataRequest<string> g = new DataRequest<string>(schedules, list[i].Url, Request_type.Schedule);
                g.FinTraitement += scheduleDownloaded;
                Debug.WriteLine(list[i].Url);
            }
        }
        private void Pivot_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            if (pivot.SelectedIndex == 0)
                currentWay = SaveData.Sens.Aller;
            else
                currentWay = SaveData.Sens.Retour;
        }

        private void AddClicked(object sender, RoutedEventArgs e)
        {
            InputPrompt inputPrompt = new InputPrompt();
            inputPrompt.Title = "Nom de l'itinéraire : ";
            inputPrompt.Completed += inputPrompt_Completed;
            inputPrompt.Show();
        }

        void inputPrompt_Completed(object sender, PopUpEventArgs<string, PopUpResult> e)
        {
            InputPrompt input = sender as InputPrompt;
            if(!offlinesData.addNewItinerary(input.Value))
                MessageBox.Show("Itinéraire " + input.Value + " déjà existant ...", "Erreur", MessageBoxButton.OK);
            else
            {
                MessageBox.Show("Itinéraire " + input.Value + " ajouté avec succès !", "Information", MessageBoxButton.OK);
                fillItineraryList();
            }
            
        }
 
        private void RemoveClicked(object sender, RoutedEventArgs e)
        {
            MessageBoxResult result = MessageBox.Show("Voulez-vous vraiment supprimer l'itinéraire " + currentItinineraryName + " ?", "Supprimer", MessageBoxButton.OKCancel);
            
            if (result == MessageBoxResult.OK)
            {
                offlinesData.delItinerary(currentItinineraryName);
                fillItineraryList();
            }
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