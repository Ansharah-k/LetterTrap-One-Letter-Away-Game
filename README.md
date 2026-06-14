# Letter Trap - Pakistan Cities Edition

A fun **Hangman-style** word guessing game written in **MIPS Assembly** for MARS Simulator, featuring famous cities of Pakistan.

## Features

- Choose from 10 major Pakistani cities
- Educational hints for each city
- Classic hangman gameplay with bitmap graphics
- Visual gallows and body parts drawn on wrong guesses
- Win screen with green celebration banner

## How to Run

### Requirements

- [MARS MIPS Simulator](https://courses.missouristate.edu/kenvollmar/mars/)

### Setup Steps

1. Open **MARS** simulator
2. Go to **Tools → Bitmap Display**
   - Unit Width = `4`
   - Unit Height = `4`
   - Display Width = `256`
   - Display Height = `256`
   - **Base Address** = `Static Data Segment (0x10010000)`
   - Click **Connect to MIPS**
3. Load `lettertrapg.asm`
4. **Assemble** (F3)
5. **Run** (F5)

### Gameplay

- Choose a city: `1-9`
- Read the hint
- Guess letters one by one
- You have **6 wrong attempts** before the hangman is complete

## Project Files

- `lettertrapg.asm` → Main game source code
- `README.md` → This documentation


## License

Educational project. Free to use and modify.

---

**Made with ❤️ for Pakistan** 🇵🇰
