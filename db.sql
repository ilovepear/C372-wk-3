-- Reconstructed CA1 milestone; safe additive schema, no DROP.
CREATE DATABASE IF NOT EXISTS petcare_ca1 CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE petcare_ca1;

CREATE TABLE IF NOT EXISTS users (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(50) NOT NULL UNIQUE,
  password CHAR(64) NOT NULL,
  name VARCHAR(100) NOT NULL,
  role ENUM('admin','user') NOT NULL DEFAULT 'user',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS pets (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  owner_id INT UNSIGNED NOT NULL,
  name VARCHAR(80) NOT NULL,
  species VARCHAR(50) NOT NULL,
  breed VARCHAR(80) NOT NULL,
  age TINYINT UNSIGNED NOT NULL,
  image VARCHAR(255) NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_pets_owner (owner_id),
  FOREIGN KEY (owner_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS journal (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  pet_id INT UNSIGNED NOT NULL,
  activity VARCHAR(120) NOT NULL,
  notes TEXT NULL,
  entry_date DATE NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_journal_pet_date (pet_id, entry_date),
  FOREIGN KEY (pet_id) REFERENCES pets(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- Demo accounts are for local class testing only.
INSERT IGNORE INTO users (id,username,password,name,role) VALUES
(1,'admin1',SHA2('admin123',256),'Hannah Admin','admin'),
(2,'amy',SHA2('user123',256),'Amy Tan','user'),
(3,'ben',SHA2('user123',256),'Ben Lim','user'),
(4,'clara',SHA2('user123',256),'Clara Ng','user');
INSERT IGNORE INTO pets (id,owner_id,name,species,breed,age,image) VALUES
(1,1,'Chester','Dog','Pomeranian',3,'1751953011050_chester.jpg'),
(2,2,'Hammy','Hamster','Syrian',1,'1751905564825_hammy.jpg'),
(3,3,'Molly','Dog','West Highland Terrier',4,'molly.jpg'),
(4,3,'Mochi','Dog','Maltese',2,'Mochi.png'),
(5,4,'Mira','Cat','Ragdoll',5,'mira.jpg');
-- Demo journal entries: only inserted when missing (prevents duplicates on re-run).
INSERT INTO journal(pet_id,activity,notes,entry_date)
SELECT 5,'Morning Play','Mira enjoyed her favourite toy',CURRENT_DATE()
WHERE EXISTS (SELECT 1 FROM pets WHERE id=5) AND NOT EXISTS (SELECT 1 FROM journal WHERE pet_id=5);
