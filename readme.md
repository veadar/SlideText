# SlideText

A macOS application that displays selected text in a full-screen, slide-like format.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Overview

SlideText is a macOS utility that enhances text presentation by transforming selected text into a series of full-screen slides. This is particularly useful for presentations, reading long texts, or focusing on specific excerpts.

## Features

*   **Full-Screen Display:** Launches in full-screen mode directly from the Services menu.
*   **Text Segmentation:** Automatically splits the received text into an array based on line breaks, punctuation marks, and commas.
*   **Introductory Slide:** Adds a brief description of the app as the first slide.
*   **Slide Navigation:** Navigate through the text slides using arrow keys (←/→) or `j`/`k` keys (vim-style navigation).
*   **Customization:** Users can adjust text size and color schemes through the app's settings.
*   **Persistent Settings:** Uses SwiftData for persistent storage of user preferences.
*   **Automatic Termination:** The app automatically closes after displaying all text slides.

## Installation

[Download](https://github.com/veadar/SlideText/tags)

## Usage

1.  Select the text you want to display in any application.
2.  Right-click (or control-click) the selected text to open the Services menu.
3.  Choose "SlideText" from the Services menu.
4.  The SlideText app will launch in full-screen mode, displaying the selected text as a series of slides.
5.  Use the arrow keys (←/→) or `j`/`k` keys to navigate between slides.

## Technology

*   Swift
*   SwiftData

## Contributing

Contributions are welcome! Please open an issue or submit a pull request.