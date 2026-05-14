# ================================================================= #
# | Creazione del DataBase Museo                  |					#
# ================================================================= #

drop database if exists DBMuseo;
create database DBMuseo;
use DBMuseo;

# ================================================================= #
# | Creazione delle tabelle                     |					#
# ================================================================= #

CREATE TABLE IF NOT EXISTS Musei (
	p_iva char (11) primary key,
	telefono varchar(10),
	email varchar (35),
	indirizzo varchar (30),
	cap int (5),
	n_civico int
)ENGINE=InnoDB;

create table if not exists Dipendenti (
	idDipendenti int primary key AUTO_INCREMENT,
	nome varchar(20),
	cognome varchar(20),
	stipendio decimal (6,2),
	ruolo enum ('curatore', 'sicurezza', 'guida turistica', 'fornitore')
)ENGINE=InnoDB;

create table if not exists Contratti(
	numeroContratto int,
	idDipendenti int,
	p_ivaMuseo char (11),
	statoContratto enum ('Attivo', 'Cessato'),
	dataInizioContratto date,
	dataFineContratto date,
	primary key (numeroContratto),
	foreign key (idDipendenti) references dipendenti (idDipendenti)
		ON DELETE RESTRICT
		ON UPDATE CASCADE,
	foreign key (p_ivaMuseo) references musei (p_iva)
		ON DELETE RESTRICT
		ON UPDATE CASCADE
)ENGINE=InnoDB;

create table if not exists stipulano(
	numeroContratto int,
	idDipendenti int,
	p_ivaMuseo char (11),
	primary key (numeroContratto,idDipendenti,p_ivaMuseo),
	foreign key (idDipendenti) references dipendenti (idDipendenti)
		ON DELETE RESTRICT
		ON UPDATE CASCADE,
	foreign key (p_ivaMuseo) references musei (p_iva)
		ON DELETE RESTRICT
		ON UPDATE CASCADE,
	foreign key (numeroContratto) references contratti (numeroContratto)
		ON DELETE RESTRICT
		ON UPDATE CASCADE
)ENGINE=InnoDB;

create table if not exists Eventi(
	p_ivaMuseo char(11),
	idSala int(3),
	data date,
	oraInizio time,
	oraFine time,
	numPosti int(250),
	tipoEventi enum ('concerto', 'conferenza', 'mostra'),
	primary key(idSala,data),
	foreign key (p_ivaMuseo) references musei (p_iva)
		ON DELETE CASCADE
		ON UPDATE CASCADE
)ENGINE=InnoDB;

create table if not exists Organizza(
	p_ivaMuseo char(11),
	idSalaEventi int(3),
	dataEvento date,
	primary key (p_ivaMuseo, idSalaEventi, dataEvento),
	foreign key (p_ivaMuseo) references musei (p_iva)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	foreign key (idSalaEventi, dataEvento) references Eventi (idSala, data)
		ON DELETE CASCADE
		ON UPDATE CASCADE
)ENGINE=InnoDB;

create table if not exists Visitatori(
	codicePrenotazione int(4) primary key,
	nome varchar(20),
	cognome varchar(20),
	email varchar(50),
	data date
)ENGINE=InnoDB;

create table if not exists Partecipano(
	idSalaEventi int(3),
	codicePrenotazioneVisitatori int(4),
	primary key (idSalaEventi, codicePrenotazioneVisitatori),
	foreign key (idSalaEventi) references eventi (idSala)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	foreign key (codicePrenotazioneVisitatori) references visitatori (codicePrenotazione)
		ON DELETE CASCADE
		ON UPDATE CASCADE
)ENGINE=InnoDB;

create table if not exists Opere(
	codOpere char(6) primary key,
	titolo varchar(20),
	autore varchar(20),
	anno int,
	codFornitore int(3),
	p_ivaMuseoOpere char(11),
	foreign key (p_ivaMuseoOpere) references musei (p_iva)
			ON DELETE RESTRICT
			ON UPDATE CASCADE,
	foreign key (codFornitore) references dipendenti (idDipendenti) 
			ON DELETE RESTRICT
			ON UPDATE CASCADE
)ENGINE=InnoDB;

create table if not exists Esposti(
	idSalaEventi int(3),
	codOpereMuseo char(6),
	primary key(codOpereMuseo,idSalaEventi),
	foreign key (idSalaEventi) references eventi (idSala)
			ON DELETE CASCADE
			ON UPDATE CASCADE,
	foreign key (codOpereMuseo) references opere (codOpere)
			ON DELETE CASCADE
			ON UPDATE CASCADE
)ENGINE=InnoDB;

create table if not exists Fornisce(
	idDipendenti int(3),
	codOpereMuseo char(6),
	primary key(codOpereMuseo,idDipendenti),
	foreign key (idDipendenti) references dipendenti (idDipendenti)
			ON DELETE RESTRICT
			ON UPDATE CASCADE,
	foreign key (codOpereMuseo) references opere (codOpere)
			ON DELETE RESTRICT
			ON UPDATE CASCADE
)ENGINE=InnoDB;


# ================================================================= #
# | Popolamento delle tabelle                   |					#
# ================================================================= #

insert into musei values
('IT123456789', '3668452565', 'MuseoBarriFirenze@gmail.com', 'via Verdi', 50100, 15),
('IT234567895', '3804985263', 'MuseoBarriVerona@gmail.com', 'via Triunvirato', 37121, 784),
('IT345678901', '4485249637', 'MuseoBarriBologna@gmail.com', 'via Leopoldo', 40121, 74),
('IT456789012', '3203205258', 'MuseoBarriMantova@gmail.com', 'via Giovanni Verga', 46100, 4),
('IT567890123', '7485258926', 'MuseoBarriTorini@gmail.com', 'via Neri',10100,15);

SHOW GLOBAL VARIABLES LIKE 'local_infile';
SET GLOBAL LOCAL_INFILE=TRUE;

LOAD DATA LOCAL INFILE "C://Users//erika//OneDrive//Desktop//progettoBDSI//Popolamento//Dipendenti.txt"
INTO TABLE dbmuseo.dipendenti
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

select * from dbmuseo.dipendenti;

LOAD DATA LOCAL INFILE "C://Users//erika//OneDrive//Desktop//progettoBDSI//Popolamento//Contratti.txt"
INTO TABLE dbmuseo.contratti
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

select * from dbmuseo.contratti;

LOAD DATA LOCAL INFILE "C://Users//erika//OneDrive//Desktop//progettoBDSI//Popolamento//Stipulano.txt"
INTO TABLE dbmuseo.stipulano
FIELDS TERMINATED BY ";"
LINES TERMINATED BY "\r\n"
IGNORE 1 LINES;

select * from dbmuseo.stipulano;

insert into eventi values
('IT456789012',201, '2024-06-14', '09:30:00', '11:00:00', 90,'mostra'),
('IT234567895',015, '2021-05-15','16:40:00', '20:00:00',80, 'conferenza'),
('IT234567895',040, '2020-11-11','20:20:00', '23:00:00',120, 'concerto'),
('IT456789012',010, '2024-05-23', '10:00:00', '12:00:00', 100, 'conferenza'),
('IT567890123',201, '2019-08-14', '15:00:00', '18:00:00', 50, 'mostra'),
('IT567890123',103, '2020-07-15', '20:30:00', '23:00:00', 200, 'concerto'),
('IT456789012',004, '2021-11-16', '14:00:00', '17:00:00', 80, 'mostra'),
('IT456789012',001, '2024-05-17', '09:30:00', '11:30:00', 120, 'conferenza'),
('IT123456789',105, '2024-07-18', '19:00:00', '22:00:00', 300, 'concerto'),
('IT567890123',062, '2021-12-19', '13:00:00', '15:00:00', 80, 'conferenza');

select* from eventi;

INSERT INTO organizza VALUES
('IT456789012',001, '2024-05-17'),
('IT123456789',105, '2024-07-18'),
('IT567890123',062, '2021-12-19'),
('IT456789012',201, '2024-06-14');

select* from organizza;

insert into visitatori values
(4011,'Mario', 'Rossi','MarioRossi80@gmail.com','2024-05-13'),
(7412, 'Lidia', 'Biancotti', 'LidiaBiancotti@gmail.com','2024-05-14'),
(6243, 'Giulio', 'Noci',  'Giulio23Noci65@gmail.com','2021-12-19'),
(8604, 'Annalisa', 'Ricci','AnnaLisaricci123@gmail.com', '2024-05-16'),
(0255, 'Luca', 'Panni', 'LucaPanni67@email.com','2024-05-17'),
(0007, 'Giovanni', 'Rossi','GiovanniRossi45_89@email.com','2024-05-19'),
(4556, 'Sara', 'Monipoli',  'SaraMonipoli@gmail.com', '2024-05-18'),
(9862, 'Alessandro', 'Vanni','AlessandrinoVanni@gmail.com',  '2021-11-16'),
(1010,'Martina', 'Canu', 'MartinaCanu02@email.com','2024-05-22'),
(8527, 'Elsa', 'Ciocci','ElsaCiocci_Rosso45@email.com', '2021-12-19');

select * from visitatori;

INSERT INTO partecipano VALUES
(001,8527),
(004,0007),
(105,0255),
(103,1010);

select * from partecipano;

LOAD DATA LOCAL INFILE "C://Users//erika//OneDrive//Desktop//progettoBDSI//Popolamento//Opere.txt"
INTO TABLE dbmuseo.opere
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

select * from dbmuseo.opere;

INSERT INTO esposti VALUES
(040,18),
(010,3),
(105,2),
(201,1);

LOAD DATA LOCAL INFILE "C://Users//erika//OneDrive//Desktop//progettoBDSI//Popolamento//Fornisce.txt"
INTO TABLE dbmuseo.fornisce
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

select * from dbmuseo.fornisce;

# ================================================================= #
# | Ulteriori vincoli espressi tramite Trigger |					#
# =================================================================	#

# Questo trigger ha la funzione di impostare lo stipendio in base al ruolo del dipendente in modo corretto,
# nel caso si dovesse andare ad inserire un record non corretto. 
#1.
DROP TRIGGER IF EXISTS assegnaStipendio;
DELIMITER $$


-- FAI UNA TABELLA O QUELLO CHE TI PARE PER FARE SI CHE QUESTO TRIGGERE LEGGA I DATI DELLO STIPENDIO IN MODO DINAMICO

CREATE TRIGGER assegnaStipendio
BEFORE INSERT 
ON dipendenti
FOR EACH ROW
BEGIN
    IF NEW.ruolo = 'Fornitore' THEN
        IF NEW.stipendio IS NULL OR NEW.stipendio < 1700.00 THEN
            SET NEW.stipendio = 1500.00;
        END IF;
    END IF;
        IF NEW.ruolo = 'Curatore' THEN
        IF NEW.stipendio IS NULL OR NEW.stipendio < 1500.00 THEN
            SET NEW.stipendio = 1500.00;
        END IF;
        END IF;
    IF NEW.ruolo = 'Sicurezza' THEN
        IF NEW.stipendio IS NULL OR NEW.stipendio < 1400.00 THEN
            SET NEW.stipendio = 1400.00;
        END IF;
        END IF;
    IF NEW.ruolo = 'Guida Turistica' THEN
        IF NEW.stipendio IS NULL OR NEW.stipendio < 1300.00 THEN
            SET NEW.stipendio = 1300.00;
        END IF;
	END IF;
END $$
DELIMITER ;

# Testo che il trigger vada a buon fine
INSERT INTO dipendenti VALUES (NULL,'Erika', 'Vallelonga', null , 'Fornitore');
INSERT INTO dipendenti VALUES (NULL,'Layla', 'Vacci', '400.00' , 'Sicurezza');
select * from dipendenti;

# Questo trigger ha la funzione di dare errore al momento in cui si va ad inserire un recod di un evento,
# la cui data,orario e sala sono già state prenotate in precedenza.

#2.
DROP TRIGGER IF EXISTS SalaOccupata;
DELIMITER $$

CREATE TRIGGER SalaOccupata
BEFORE INSERT 
ON eventi
FOR EACH ROW
BEGIN
 DECLARE num_rows INT;
    #Controlla se esiste già un evento con la stessa data, orario e sala
    SELECT COUNT(*) INTO num_rows
    FROM eventi
    WHERE data = NEW.data
        AND oraInizio = NEW.oraInizio
        AND idSala = NEW.idSala;
    IF num_rows > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La data, l\'orario e la sala sono già stati prenotati in precedenza.';
    END IF;
 END $$
DELIMITER ; 

# Testo che il trigger vada a buon fine
#INSERT INTO eventi  VALUES ('IT456789012',1, '2024-05-17','09:30:00', '11:30:00', 100, 'mostra');
#select * from eventi; 

# ================================================================= #
# | Funzione |														#
# =================================================================	#

#Creo una funzione che tramite id del dipendente mi restituisca:
# 0 --> se il contratto è cessato.
#1 --> se il contratto è attivo.
#Null --> se l'id del dipendente non è valido

DROP FUNCTION IF EXISTS getStatoContratto;
DELIMITER $$

CREATE FUNCTION getStatoContratto(idDipendente INT) 
RETURNS BOOLEAN
LANGUAGE SQL
NOT DETERMINISTIC 
READS SQL DATA
BEGIN
    DECLARE statoContratto VARCHAR(10);
    DECLARE stato BOOLEAN;
    -- Seleziona lo stato del contratto per il dipendente specificato
    SELECT c.statoContratto
    INTO statoContratto
    FROM contratti c
    INNER JOIN dipendenti d ON d.idDipendenti = c.idDipendenti
    WHERE d.idDipendenti = idDipendente
    LIMIT 1;
    -- Assegna il valore booleano in base allo stato del contratto
    IF statoContratto = 'Cessato' THEN
        SET stato = FALSE;
    ELSEIF statoContratto = 'Attivo' THEN
        SET stato = TRUE;
    ELSE
        SET stato = NULL;
    END IF;
    RETURN stato;
END $$
DELIMITER ;

#testo che la funzione vada a buon fine
SELECT getStatoContratto(6) AS StatoContratto;
SELECT getStatoContratto(1) AS StatoContratto;
SELECT getStatoContratto(0) AS StatoContratto;

# ================================================================= #
# | Procedure |														#
# =================================================================	#

# Si vuole creare una procedura che conti quanti eventi ci sono stati negli anni suddivisi in mostre, concerti e conferenze
#1.
DROP PROCEDURE IF EXISTS ContaEventiAnno;
DELIMITER $$

CREATE PROCEDURE ContaEventiPerTipoAnno()
LANGUAGE SQL
NOT DETERMINISTIC
READS SQL DATA
BEGIN
    SELECT tipoeventi, count(*) as numero_eventi, year(data) 
	from eventi
	group by tipoeventi, year(data);
END $$ 
DELIMITER ;

# Testo la Procedura vada a buon fine.
CALL ContaEventiPerTipoAnno();


# Si vuole creare una procedura che tramite la data vada ad eliminare tutti gli eventi passati,
# per far rimanere solo quelli che ancora devono avvenire.
#2.
DROP PROCEDURE IF EXISTS eliminaEventiOrganizzatiPassati;
DELIMITER $$

CREATE PROCEDURE eliminaEventiOrganizzatiPassati()
LANGUAGE SQL
NOT DETERMINISTIC
MODIFIES SQL DATA
BEGIN
SET SQL_SAFE_UPDATES = 0;
delete from organizza where dataEvento < now();
SET SQL_SAFE_UPDATES = 1;
END $$
DELIMITER ;

CALL eliminaEventiOrganizzatiPassati();
select * from organizza;

# ================================================================= #
# | Viste                |											#
# =================================================================	#

# Vista storico contratti scaduti, contiene tutti i contratti che non sono più validi
#1.
CREATE VIEW contrattiScaduti AS
SELECT *
FROM contratti c
WHERE c.statoContratto = 'cessato'
with local check option;

# Testo che la vista funzioni
select * from contrattiScaduti ;

# Vista di quali opere si trovano all'interno del museo con partita iva IT456789012
CREATE VIEW opereInterneAlMuseo AS
SELECT *
FROM opere o
WHERE o.p_ivaMuseoOpere = 'IT456789012'
with local check option;

#Testo che la vista funzioni
select * from opereInterneAlMuseo;

# ================================================================= #
# | Interrogazioni                   |								#
# =================================================================	#

# 1. conta tutte le partite iva dei musei 
SELECT count(*)
AS p_iva 
FROM musei; 

#2.Trovare tutti gli eventi che ci sono stati tra 2020-11-11 e 2021-11-16.
SELECT *
FROM eventi
WHERE data BETWEEN ('2020-11-11') AND ('2021-11-16')
ORDER BY DATA;

#3.Trovare tutti i dipendenti che appartengono al Museo con Partita iva "IT456789012"
SELECT nome,cognome
FROM dipendenti 
JOIN contratti c ON dipendenti.idDipendenti=c.idDipendenti
JOIN musei m ON c.p_ivaMuseo = m.p_iva
WHERE m.p_iva="IT456789012";

#4. Elencare indirizzo, cap e n_civico di un museo che ha almeno due opere
SELECT indirizzo,cap, n_civico, titolo
FROM musei
JOIN opere ON musei.p_iva = opere.p_ivaMuseoOpere
WHERE p_iva IN (SELECT p_ivaMuseoOpere
				FROM opere
                GROUP BY p_ivaMuseoOpere
                HAVING COUNT(*)>=2);
 
 



    

















