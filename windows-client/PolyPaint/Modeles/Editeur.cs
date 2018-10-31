﻿using PolyPaint.Modeles.Outils;
using PolyPaint.Modeles.Strokes;
using PolyPaint.Modeles.Tools;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Windows;
using System.Windows.Ink;
using System.Windows.Media;

namespace PolyPaint.Modeles
{
    /// <summary>
    /// Modélisation de l'éditeur.
    /// Contient ses différents états et propriétés ainsi que la logique
    /// qui régis son fonctionnement.
    /// </summary>
    class Editeur : INotifyPropertyChanged
    {
        public event PropertyChangedEventHandler PropertyChanged;
        public CustomStrokeCollection traits = new CustomStrokeCollection();
        private CustomStrokeCollection traitsRetires = new CustomStrokeCollection();

        private Tool Lasso = new Lasso();
        private Tool Pencil = new Pencil();
        private Tool SegmentEraser = new SegmentEraser();
        private Tool ObjectEraser = new ObjectEraser();
        private Tool Rectangle = new Rectangle();
        private Tool Elipse = new Elipse();
        private Tool Person = new Person();
        private Tool Line = new Line();
        private Tool ClassDiagram = new ClassDiagram();
        public List<Tool> Tools;

        // Outil actif dans l'éditeur
        private Tool outilSelectionne;
        public Tool OutilSelectionne
        {
            get { return outilSelectionne; }
            set { outilSelectionne = value; ProprieteModifiee(); }
        }


        // Class diagram preview
        private string classContent;
        public string ClassContent
        {
            get { return classContent; }
            set { classContent = value; ProprieteModifiee(); }
        }
        private string editingStroke;
        public string EditingStroke
        {
            get { return editingStroke; }
            set
            {
                if (this.editingStroke != null && this.traits.has(this.editingStroke))
                {
                    Console.WriteLine("stopedition");
                    this.traits.get(this.editingStroke).stopEditing();
                }

                this.editingStroke = value;
            }
        }

        // Forme de la pointe du crayon
        private string pointeSelectionnee = "ronde";
        public string PointeSelectionnee
        {
            get { return pointeSelectionnee; }
            set
            {
                OutilSelectionne = Pencil;
                pointeSelectionnee = value;
                ProprieteModifiee();
            }
        }

        // Couleur des traits tracés par le crayon.
        private string couleurSelectionnee = "Black";
        public string CouleurSelectionnee
        {
            get { return couleurSelectionnee; }
            // Lorsqu'on sélectionne une couleur c'est généralement pour ensuite dessiner un trait.
            // C'est pourquoi lorsque la couleur est changée, l'outil est automatiquement changé pour le crayon.
            set
            {
                couleurSelectionnee = value;
                ProprieteModifiee();
            }
        }

        // Grosseur des traits tracés par le crayon.
        private int tailleTrait = 11;
        public int TailleTrait
        {
            get { return tailleTrait; }
            // Lorsqu'on sélectionne une taille de trait c'est généralement pour ensuite dessiner un trait.
            // C'est pourquoi lorsque la taille est changée, l'outil est automatiquement changé pour le crayon.
            set
            {
                tailleTrait = value;
                ProprieteModifiee();
            }
        }

        public Editeur()
        {
            this.outilSelectionne = this.Lasso;

            this.Tools = new List<Tool>();
            this.Tools.Add(Lasso);
            //this.Tools.Add(Pencil);
            //this.Tools.Add(SegmentEraser);
            this.Tools.Add(ObjectEraser);
            this.Tools.Add(Rectangle);
            this.Tools.Add(Elipse);
            this.Tools.Add(Person);
            this.Tools.Add(Line);
            this.Tools.Add(ClassDiagram);
            this.classContent = "";
        }

        /// <summary>
        /// Appelee lorsqu'une propriété d'Editeur est modifiée.
        /// Un évènement indiquant qu'une propriété a été modifiée est alors émis à partir d'Editeur.
        /// L'évènement qui contient le nom de la propriété modifiée sera attrapé par VueModele qui pourra
        /// alors prendre action en conséquence.
        /// </summary>
        /// <param name="propertyName">Nom de la propriété modifiée.</param>
        protected void ProprieteModifiee([CallerMemberName] string propertyName = null)
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
        }

        // S'il y a au moins 1 trait sur la surface, il est possible d'exécuter Empiler.
        public bool PeutEmpiler(object o) => (traits.Count > 0);

        internal void MouseUp(Point point)
        {
            this.outilSelectionne.MouseUp(point, traits);
        }

        internal void SelectStrokes(StrokeCollection strokes)
        {
            strokes.ToList().ForEach(stroke => {
                if (((CustomStroke)stroke).isSelected())
                {
                    if (((CustomStroke)stroke).isEditing())
                        this.EditingStroke = null;

                    ((CustomStroke)stroke).Unselect();
                }
                else
                {
                    ((CustomStroke)stroke).Select();
                    if (stroke.GetType() == typeof(ClassStroke))
                    {
                        ClassStroke classStroke = (ClassStroke)stroke;
                        classStroke.textContent.ForEach(textLine => {
                            this.ClassContent = this.ClassContent + textLine + "\r\n";
                        });
                    }
                }
            });
        }

        internal void Edit(CustomStroke stroke)
        {
            if (stroke.isLocked()) return;
            if (!stroke.isSelected()) return;

            if (stroke.isEditing())
            {
                this.EditingStroke = null;
            } else
            {
                stroke.startEditing();
                this.EditingStroke = stroke.Id.ToString();
            }
        }

        internal void MouseMove(Point point)
        {
            this.outilSelectionne.MouseMove(point, traits, (Color)ColorConverter.ConvertFromString(couleurSelectionnee));
        }

        internal void MouseDown(Point point)
        {
            this.outilSelectionne.MouseDown(point, traits);
        }

        // On retire le trait le plus récent de la surface de dessin et on le place sur une pile.
        public void Empiler(object o)
        {
            try
            {
                Stroke trait = traits.Last();
                traitsRetires.Add(trait);
                traits.Remove(trait);               
            }
            catch { }

        }

        // S'il y a au moins 1 trait sur la pile de traits retirés, il est possible d'exécuter Depiler.
        public bool PeutDepiler(object o) => (traitsRetires.Count > 0);
        // On retire le trait du dessus de la pile de traits retirés et on le place sur la surface de dessin.
        public void Depiler(object o)
        {
            try
            {
                Stroke trait = traitsRetires.Last();
                traits.Add(trait);
                traitsRetires.Remove(trait);
            }
            catch { }         
        }
        
        // On assigne une nouvelle forme de pointe passée en paramètre.
        public void ChoisirPointe(string pointe) => PointeSelectionnee = pointe;

        // L'outil actif devient celui passé en paramètre.
        public void ChoisirOutil(Tool tool) => OutilSelectionne = tool;

        // On vide la surface de dessin de tous ses traits.
        public void Reinitialiser(object o) => traits.Clear();
        
        public void ChangeClassContent(string content)
        {
            if (this.traits.has(EditingStroke) && this.traits.get(EditingStroke).GetType() == typeof(ClassStroke))
            {
                ClassStroke editingClass = (ClassStroke)this.traits.get(EditingStroke);
                char[] chartab = { '\r', '\n' };
                editingClass.textContent = content.Split(chartab, StringSplitOptions.RemoveEmptyEntries).ToList();
                editingClass.Refresh();
            }
        }
    }
}