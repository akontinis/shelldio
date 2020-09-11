# Shelldio

Ένα απλό shell script για να παίζετε τους αγαπημένους σας ραδιοφωνικούς σταθμούς στο τερματικό. 

## Οδηγίες εγκατάστασης

Το Shelldio είναι συμβατό με Linux, BSD και macOS. Απαιτείται το πακέτο ```mpv``` για να δουλεψει. Μπορείτε να το εγκαταστήσετε από το αποθετήριο λογισμικών της διανομής σας.

### Arch Linux

Για να το κάνετε εγκατάσταση σε Arch Linux αρκεί να έχετε ενεργό το AUR οπότε, με έναν AUR helper κάντε εγκατάσταση το  **shelldio** 

```yay -S shelldio```

το οποίο θα κάνει αυτόματα εγκατάσταση και το `mpv` που χρειάζεστε. Τώρα μπορείτε να πάτε παρακάτω στις οδηγίες χρήσης.

### Στις υπόλοιπες διανομές

Για να το εγκαταστήσετε στις υπόλοιπες διανομές πρώτα κάνετε εγκατάσταση το **Mpv**

#### Σε Debian based διανομές

```sudo apt install mpv```

#### Σε Fedora based διανομές

```sudo dnf -y install mpv```

#### Σε OpenSuse Linux

```sudo zypper in mpv```

#### Σε CentOS Linux (από το nux-desktop repository)

```sudo yum -y install mpv```

#### Σε FreeBSD Unix

```sudo pkg install mpv```

έπειτα τρέχετε μια μια τις παρακάτω εντολές:

```
git clone https://github.com/CerebruxCode/shelldio ~/shelldio
cp -r ~/shelldio/.shelldio/ ~/.shelldio
sudo ln -s ~/shelldio/shelldio.sh /usr/bin/shelldio
```

## Οδηγίες Αναβάθμισης

Οι αναβαθμίσεις περιλαμβάνουν διορθώσεις, ενημέρωση και προσθήκη νέων σταθμών.

### Arch Linux

Οι ενημερώσεις θα σας έρθουν αυτόματα την επόμεη φορά που θα κάνετε αναβάθμιση το Arch Linux σας.

### Υπόλοιπες διανομές

Μπείτε στον φάκελο shelldio που κάνατε `git clone` και τρέξετε κατά διαστήματα "git pull". Στην συνέχεια αντιγράψτε μόνο το αρχείο "all_stations.txt" το οποίο μπορεί να έχει ενημερωθεί με νέους σταθμούς η διορθωμένα λινκ:

```
cp ~/shelldio/.shelldio/all_stations.txt ~/.shelldio/all_stations.txt
```

## Οδηγίες Απεγκατάστασης

Ανάλογα του τρόπου εγκατάστασης μπορείτε να απεγκαταστείσετε το Shelldio με τους παρακάτω τρόπους

### Arch Linux

Μπορείτε να το απεγκαταστήσετε με τον AUR helper σας π.χ.:
```
yay -Rcsu shelldio
```
### Υπόλοιπες διανομές

Τρέξτε τις ποαρακάτω εντολές :

```
sudo unlink /usr/bin/shelldio
rm -rf ~/.shelldio
```
Τέλος μπορείτε να διαγράψετε κιαι τον φάκελο που κατεβήκε με `git clone`
```
rm -rf ~/shelldio
```
## Οδηγίες χρήσης

Εξ'ορισμού το script αν δε δοθεί όρισμα στο τερματικό ανοίγει τη λίστα με τους σταθμούς που είναι αποθηκευμένοι στο ```~/.shelldio/my_stations.txt```. 
Οπότε δώστε στο τερματικό σας:

```
shelldio
```
Αλλιώς μπορείτε να φορτώσετε το μεγάλο αρχείο με πάνω απο 100+ σταθμούς με την παρακάτω εντολή:

```shelldio ~/.shelldio/all_stations.txt```

Μπορείτε επίσης να κάνετε αναζήτηση για κάποιον σταθμό χρησιμοποιώντας την παρακάτω εντολή:

```
shelldio ~/.shelldio/all_stations.txt | grep -i "onoma_stathmou"
```
θα σας εμφανήσει τον αριθμό. Πατάτε `Q` για να σταματήσετε την αναζήτηση και έπειτα τρεχετε ```shelldio ~/.shelldio/all_stations.txt``` και βάζετε τον αριθμό του σταθμού που αναζητήσατε. Με αυτόν τον τρόπο μπορείτε να μαζέψετε π.χ. τους αγαπημένους σας σταθμους και να τους αντιγράψετε στο ```~/.shelldio/my_stations.txt``` με έναν απλό κειμενογράφο προκειμένου να έχετε μια μικρή λίστα με τους σταθμούς που ακούτε πιο συχνά.

## Πως βάζω νέους σταθμούς;

Φυσικά το **shelldio** υποστηρίζει και φόρτωση δικού σας αρχείου δίνοντας στο τερματικό 

```./shelldio όνομα_αρχείου.txt```

Απλά προσθέστε το όνομα και το URL του σταθμού στο αρχείο σας ή απευθείας στο ```~/.shelldio/my_stations.txt``` όπου κάθε γραμμή πρέπει να είναι της μορφής 

```Όνομα σταθμού,URL_σταθμού```

Μπορείτε να ανοίξετε με έναν κειμενογράφο το αρχείο `my_stations.txt` για να πάρετε μια ιδέα στο πως πρέπει να είναι γραμμένος ο σταθμός που προσθέτετε.
