using PolyPaint.Utilitaires;
using System.Windows.Media.Imaging;

namespace PolyPaint.Modeles
{
    public class User
    {
        public string id { get; set; }
        public string token { get; set; }
        public string username { get; set; }
        public System.Uri profileImage { get; set; }
        public string userLevel { get; set; }
        public string password { get; set; }
        public bool isGuest { get; set; }

        public User() {}

        public User(string username)
        {
            this.username = username;
            this.profileImage = new System.Uri(Settings.DEFAULT_PROFILE_IMAGE);
            this.isGuest = false;
        }

        public User(string username, string id, string profileImage, string token, string userLevel, string password, bool isGuest)
        {
            this.username = username;
            this.id = id;
            this.profileImage = new System.Uri(profileImage);
            this.token = token;
            this.userLevel = userLevel;
            this.password = password;
            this.isGuest = isGuest;
        }

        public User(string username, string id, string profileImage)
        {
            this.username = username;
            this.id = id;
            this.profileImage = new System.Uri(profileImage);
            this.isGuest = false;
        }
    }
}