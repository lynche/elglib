﻿package Elegant.media.anttikupila.revolt.presets {	import Elegant.media.anttikupila.revolt.presets.Preset;	import Elegant.media.anttikupila.revolt.drawers.*;	import Elegant.media.anttikupila.revolt.effects.*;	import Elegant.media.anttikupila.revolt.scalers.*;		public class Tunnel extends Preset {				function Tunnel() {			super();			drawers = new Array(new TunnelDrawer());			scalers = new Array(new ZoomIn());			var perlin:Perlin = new Perlin(10,10);			perlin.interval = 3748;			effects = new Array(perlin);		}				override public function toString():String {			return "Smooth line without fourier transformation";		}	}}