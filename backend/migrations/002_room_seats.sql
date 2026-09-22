-- TOYO migration 002: upgrade legacy room-seat constraints
DO $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM pg_constraint
    WHERE conrelid='rooms'::regclass AND conname='rooms_max_seats_check'
  ) THEN
    ALTER TABLE rooms DROP CONSTRAINT rooms_max_seats_check;
  END IF;
END $$;

ALTER TABLE rooms
  ADD CONSTRAINT rooms_max_seats_check CHECK (max_seats BETWEEN 1 AND 15);

ALTER TABLE rooms ALTER COLUMN max_seats SET DEFAULT 8;

INSERT INTO room_seats(room_id,seat_no)
SELECT r.id, s.seat_no
FROM rooms r
CROSS JOIN generate_series(1,15) AS s(seat_no)
WHERE s.seat_no <= r.max_seats
  AND NOT EXISTS (
    SELECT 1 FROM room_seats rs
    WHERE rs.room_id=r.id AND rs.seat_no=s.seat_no
  );
