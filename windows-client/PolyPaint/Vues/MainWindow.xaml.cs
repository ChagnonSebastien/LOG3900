﻿using System;
using System.Windows;
using System.Windows.Forms;
using System.Windows.Media.Imaging;
using PolyPaint.DAO;
using PolyPaint.Services;
using PolyPaint.Utilitaires;

namespace PolyPaint.Vues
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        public Gallery Gallery;
        public Users Users;
        public FenetreDessin FenetreDessin;

        public MainWindow()
        {
            Server_Connect();
            UsersManager.instance.fetchAll();
            FenetreDessin = new FenetreDessin();
            InitializeComponent();
            Gallery = new Gallery();
            Users = new Users();
            GridMain.Content = Gallery;
            InitDialogBox();
            if (ServerService.instance.user.isGuest)
            {
                RestrictPermissions();
            }
            else
            {
                Uri profileImage = ServerService.instance.user.profileImage;
                if(profileImage != null)
                {
                    AvatarImage.Source = new BitmapImage(profileImage);
                }
            }
        }

        private void RestrictPermissions()
        {
            ManageProfileButton.Visibility = Visibility.Collapsed;
            AvatarButton.IsEnabled = false;
        }

        private void Server_Connect()
        {
            LoginDialogBox dlg = new LoginDialogBox();
            if (dlg.ShowDialog() == false)
            {
                System.Environment.Exit(0);
            }
        }

        private void Button_Click(object sender, RoutedEventArgs e)
        {
            int index = int.Parse(((System.Windows.Controls.Button)e.Source).Uid);

            GridCursor.Margin = new Thickness(10 + (150 * index), 0, 0, 0);

            switch (index)
            {
                case 0:
                    {
                        Gallery.Load();
                        GridMain.Content = Gallery;
                        break;
                    }
                case 1:
                    {
                        Users.Load();
                        GridMain.Content = Users;
                        break;
                    }
                case 2:
                    GridMain.Content = MessagingViewManager.instance.LargeMessagingView;
                    break;
                case 3:
                    GridMain.Content = this.FenetreDessin;
                    break;
            }
        }

        private void Menu_Change_Avatar_Click(object sender, System.EventArgs e)
        {
            string fileName = null;

            using (OpenFileDialog openFileDialog1 = new OpenFileDialog())
            {
                openFileDialog1.InitialDirectory = "c:\\";
                openFileDialog1.Filter = "Image files (*.jpg, *.jpeg, *.jpe, *.jfif, *.png) | *.jpg; *.jpeg; *.jpe; *.jfif; *.png";
                openFileDialog1.FilterIndex = 2;
                openFileDialog1.RestoreDirectory = true;

                if (openFileDialog1.ShowDialog().ToString().Equals("OK"))
                {
                    fileName = openFileDialog1.FileName;
                }
            }

            if (fileName != null)
            {
                String avatarLocation = fileName;
                BitmapImage bitmap = new BitmapImage();
                bitmap.BeginInit();
                bitmap.UriSource = new Uri(avatarLocation);
                bitmap.DecodePixelHeight = 40;
                bitmap.DecodePixelWidth = 40;
                bitmap.EndInit();
                AvatarImage.Source = bitmap;

                ServerService.instance.S3Communication.UploadFileAsync(avatarLocation);

                Uri avatarImageToUploadToSQL = new Uri(Settings.URL_TO_PROFILE_IMAGES + ServerService.instance.user.id);
                ServerService.instance.user.profileImage = avatarImageToUploadToSQL;
                UserDao.Put(ServerService.instance.user);
            }
        }

        private void InitDialogBox()
        {
            CurrentProfileName.Text = ServerService.instance.user.username;
            CurrentProfilePassword.Password = ServerService.instance.user.password;
        }

        private void ChangeProfileInformationsButton_Click(object sender, System.EventArgs e)
        {
            ServerService.instance.user.username = CurrentProfileName.Text;
            ServerService.instance.user.password = CurrentProfilePassword.Password;
            UserDao.Put(ServerService.instance.user);
            ChangeProfileInformationsButton.IsEnabled = false;
        }

        private void CloseDialogButton_Click(object sender, RoutedEventArgs e)
        {
            InitDialogBox();
            ChangeProfileInformationsButton.IsEnabled = false;
        }

        private void CurrentProfileInformations_KeyUp(object sender, System.Windows.Input.KeyEventArgs e)
        {
            Boolean invalideUserName = CurrentProfileName.Text.Length == 0 || CurrentProfileName.Text.Contains(" ");
            Boolean invalidPassword = CurrentProfilePassword.Password.Length == 0 || CurrentProfilePassword.Password.Contains(" ");

            if (invalideUserName || invalidPassword)
            {
                ChangeProfileInformationsButton.IsEnabled = false;
            }
            else
            {
                ChangeProfileInformationsButton.IsEnabled = true;
            }
        }

        public void LoadImage(string imageId)
        {
            ServerService.instance.currentImageId = imageId;
            ButtonEdit.Visibility = Visibility.Visible;
            GridMain.Content = FenetreDessin;
        }

    }
}
