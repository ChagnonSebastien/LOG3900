﻿using PolyPaint.VueModeles;
using PolyPaint.Vues;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Controls;

namespace PolyPaint.Services
{
    class MessagingViewManager
    {
        private static MessagingViewManager _instance;

        public static MessagingViewManager instance
        {
            get
            {
                if (MessagingViewManager._instance == null)
                {
                    MessagingViewManager._instance = new MessagingViewManager();
                }
                return MessagingViewManager._instance;
            }
        }

        public MessagingWindow LargeMessagingView { get; set; }
        public MessagingWindowOutside DetachedMessagingView { get; set; }

        public MessagingViewManager()
        {
            this.loadViews();
        }

        public void loadViews()
        {
            MessagingViewModel viewModel = new MessagingViewModel();
            this.DetachedMessagingView = new MessagingWindowOutside(viewModel);
            this.LargeMessagingView = new MessagingWindow(viewModel);
        }
    }
}
