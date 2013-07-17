﻿package Elegant.media.anttikupila.revolt.presets {	import Elegant.media.anttikupila.revolt.presets.Preset;	import Elegant.media.anttikupila.revolt.drawers.*;	import Elegant.media.anttikupila.revolt.effects.*;	import Elegant.media.anttikupila.revolt.scalers.*;		public class LineFourier extends Preset {		function LineFourier() {			super();			fourier = true;			drawers = new Array(new Line());			effects = new Array(new Blur(), new Perlin(5,2));			scalers = new Array(new ZoomOut());		}				override public function toString():String {			return "Line with fourier transformation";		}	}}