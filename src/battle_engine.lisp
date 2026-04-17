;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Weapons

(defclass weapon ()
  ((damage :initarg :damage
           :accessor weapon-damage
           :accessor damage
           :initform 50)))

(defmethod print-object ((object weapon) stream)
  (print-unreadable-object (object stream :type t)
    (format stream "(~d damage)" (damage object))))

(defgeneric damage-type (weapon)
  (:method-combination append))

(defmethod absorption ((object weapon)) 0)
(defmethod absorption ((object null)) 0)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Sword

(defclass sword (weapon) ())

(defmethod damage-type append ((weapon sword))
  '(:slashing))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Spear

(defclass spear (weapon) ())

(defmethod damage-type append ((weapon spear))
  '(:piercing))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Club

(defclass club (weapon) ())

(defmethod damage-type append ((weapon club))
  '(:blunt))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Multi-type weapon

(defclass very-blunt-and-pointy-sword (club spear sword) ())

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Beings

(defclass being ()
  ((health :initarg :health :accessor health)
   (max-health :initarg :health :accessor max-health)
   (weapon :initarg :weapon :accessor weapon)
   (on-death :initarg :on-death
             :initform (list #'on-death-hook)
             :accessor on-death))
  (:default-initargs :health 100 :weapon nil))

(defmethod (setf health) :after (newval (being being))
  (when (and (zerop newval)
             (not (zerop (health being))))
    (loop for hook in (on-death being)
          do (funcall hook being))))

(defun on-death-hook (being)
  (when (zerop (health being))
    (format t "VICTOR ~%YOUR OPPONENT HAS BEEN DEFEATED~%")))

(defmethod print-object ((object being) stream)
  (print-unreadable-object (object stream :type t)
    (format stream "(~D health)" (health object))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Monsters

(defclass monster (being)
  ((rage-threshold :initarg :rage-threshold :accessor rage-threshold :initform 150)
   (rage-damage :initarg :rage-damage :accessor rage-damage :initform 50))
  (:default-initargs :health 100))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Players

(defclass player (being)
  ((name :initarg :name :accessor name)
   (mana :initarg :mana :accessor mana)
   (healing-power :initarg :healing-power :accessor healing-power :initform 50)
   (health-threshold :initarg :health-threshold :accessor health-threshold :initform 100)
   (inventory :initform () :accessor inventory)
   (level :initform 1 :accessor level)
   (experience :initform 0 :accessor experience)
   (special-ability :initarg :special-ability :accessor special-ability)
   (unique-items :initform () :accessor unique-items)
   (perk :initarg :perk :accessor perk)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Player factories

(defun create-warrior (name)
  (make-instance 'player
                 :name name
                 :health 250
                 :mana 20
                 :special-ability 'shield-block
                 :unique-items '("Battle Axe" "Steel Armor")
                 :perk 'extra-health))

(defun create-mage (name)
  (make-instance 'player
                 :name name
                 :health 150
                 :mana 100
                 :special-ability 'fireball
                 :unique-items '("Wand of Wisdom" "Robe of Mana")
                 :perk 'extra-mana))

(defun create-thief (name)
  (make-instance 'player
                 :name name
                 :health 120
                 :mana 50
                 :special-ability 'backstab
                 :unique-items '("Dagger of Speed" "Cloak of Shadows")
                 :perk 'critical-hit))

(defun create-zombie (name)
  (make-instance 'player
                 :name name
                 :health 200
                 :mana 0
                 :special-ability 'undead-resilience
                 :unique-items '("Rotting Claws" "Bone Shield")
                 :perk 'poison-immune))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Defensive mixin

(defclass defensive-mixin ()
  ((absorption :initarg :absorption :accessor absorption :initform 20)))

(defmethod damage-type append ((weapon defensive-mixin))
  '(:defensive))

(defclass defensive-spear (defensive-mixin spear) ())
(defclass defensive-club (defensive-mixin club) ())

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Magical mixin

(defclass magical-mixin ()
  ((modifier :initarg :modifier :initform 0 :accessor modifier)))

(defmethod damage ((object magical-mixin))
  (+ (call-next-method) (modifier object)))

(defmethod damage-type append ((weapon magical-mixin))
  '(:magical))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Epic mixin

(defclass epic-mixin ()
  ((multiplier :accessor multiplier :initarg :multiplier :initform 2)))

(defmethod damage ((object epic-mixin))
  (* (call-next-method) (multiplier object)))

(defmethod damage-type append ((weapon epic-mixin))
  '(:epic))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Holy mixin

(defclass holy-mixin (magical-mixin)
  ((multiplier :accessor multiplier :initarg :multiplier :initform 2)))

(defmethod damage ((object holy-mixin))
  (* (call-next-method) (multiplier object)))

(defmethod damage-type append ((weapon holy-mixin))
  '(:holy))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Ghost

(defclass ghost (monster) ()
  (:default-initargs :health 400))

(defmethod hit ((who being) (whom ghost) &key)
  (let ((weapon (weapon who)))
    (if (member :magical (damage-type weapon))
        (call-next-method)
        (values nil 0 (health whom)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Ogre (ghost-inside behavior)

(defclass ghost-inside-mixin () ())

(defmethod hit :after (who (whom ghost-inside-mixin) &key)
  (when (zerop (health whom))
    (change-class whom 'ghost :health 50)))

(defclass ogre (ghost-inside-mixin monster) ()
  (:default-initargs :health 800))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Zombie

(defclass zombie (monster)
  ((regeneration :initarg :regeneration :accessor regeneration)
   (max-regeneration :initarg :regeneration :accessor max-regeneration))
  (:default-initargs :regeneration 50))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Combat

(defgeneric compute-damage (who whom weapon shield &key &allow-other-keys))

(defmethod compute-damage (who whom (weapon weapon) (shield null) &key)
  (max 0 (- (damage weapon) (absorption shield))))

(defgeneric hit (who whom &key &allow-other-keys))

(defmethod hit ((who being) (whom being) &key max-damage)
  (let* ((weapon (weapon who))
         (damage (compute-damage who whom weapon nil))
         (damage (min (health whom) damage)))
    (format t "~a hits ~a for ~d damage~%" who whom damage)
    (decf (health whom) damage)
    (values t damage (health whom))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Healing

(defgeneric heal (who))

(defmethod heal ((player player))
  (let ((heal-amount (healing-power player)))
    (setf (health player)
          (min (+ (health player) heal-amount)
               (max-health player)))
    (format t "~a heals for ~d~%" (name player) heal-amount)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Battle loop

(defun battle (being-1 being-2)
  (loop while (and (> (health being-1) 0)
                   (> (health being-2) 0))
        do (hit being-1 being-2)
           (when (> (health being-2) 0)
             (hit being-2 being-1))
           (when (> (health being-1) 0)
             (heal being-1))
           (when (> (health being-2) 0)
             (heal being-2)))
  (format t "~a wins!~%"
          (if (> (health being-1) 0)
              being-1
              being-2)))