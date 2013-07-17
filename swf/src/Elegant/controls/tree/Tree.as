package Elegant.controls.tree
{
	import Elegant.config.ELGFla;
	import Elegant.display.Container;
	import Elegant.layout.HBox;
	import Elegant.layout.VBox;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	/**
	 * 树
	 * @author 小痛
	 */
	public class Tree extends Container
	{
		public static var iconCreator:IconCreator = new IconCreator();
		
		private var noteVec:Vector.<Tree> = new Vector.<Tree>();
		private var label:TextField = new TextField();
		private var iconContainer:Sprite = new Sprite();
		private var vbox:VBox = new VBox(5);
		private var _parentNote:Tree;
		
		//private var _autoHideEmptyNote:Boolean;
		
		/**
		 * @inheritDoc
		 */
		public function Tree()
		{
			super();
			
			var iconBitmap:Bitmap = new Bitmap();
			iconContainer.buttonMode = true;
			iconContainer.mouseChildren = false;
			
			iconContainer.addChild(iconBitmap);
			iconContainer.addEventListener(MouseEvent.CLICK, iconClickHandler);
			ELGFla::icon = iconCreator.terminalIcon;
			
			label.x = 10;
			label.selectable = false;
			
			addChild(iconContainer);
			addChild(label);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function dispose():void
		{
			iconContainer.removeEventListener(MouseEvent.CLICK, iconClickHandler);
			super.dispose();
		}
		
		/**
		 * 加入新的节点
		 * @param	tree
		 * @return	返回新的长度
		 */
		public function addNote(tree:Tree):int
		{
			if (tree.parentNote)
				tree.parentNote.removeNote(tree);
			
			var i:int = noteVec.push(tree);
			if (_showing)
			{
				ELGFla::icon = iconCreator.spreadIcon;
				
				vbox.addChild(tree);
				dispatchEvent(new Event(Event.CHANGE));
			} else {
				ELGFla::icon = iconCreator.mergeIcon;
				
			}
			
			tree.addEventListener(Event.CHANGE, onSubNoteChange);
			return i;
		}
		
		/**
		 * 移除节点
		 * @param	tree
		 * @return
		 */
		public function removeNote(tree:Tree):Tree
		{
			if (tree.parent == vbox)
				vbox.removeChild(tree);
			
			noteVec.splice(noteVec.indexOf(tree), 1);
			tree.removeEventListener(Event.CHANGE, onSubNoteChange);
			return tree;
		}
		
		/**
		 * 获取指定位置的节点
		 * @param	index
		 * @return
		 */
		public function getNoteAt(index:int):Tree
		{
			return noteVec[index];
		}
		
		//----------------------EventHandler-----------------------------
		/**
		 * 图标点击事件
		 * @param	e
		 */
		private function iconClickHandler(e:MouseEvent):void
		{
			if (numNotes == 0)
				return;
			
			_showing = !_showing;
			
			//展开状态
			if (_showing)
			{
				ELGFla::icon = iconCreator.spreadIcon;
				
			} else {
				ELGFla::icon = iconCreator.mergeIcon;
				
			}
		}
		
		private function onSubNoteChange(e:Event):void 
		{
			
		}
		
		//----------------------getter / setter--------------------------
		/**
		 * @inheritDoc
		 */
		override public function get name():String
		{
			return label.text;
		}
		
		override public function set name(value:String):void
		{
			label.htmlText = value;
			label.height = label.textHeight + 2;
			
			iconContainer.y = (label.height - iconContainer.height) >> 1;
		}
		
		/**
		 * 返回是否为展开状态
		 */
		override public function get showing():Boolean
		{
			return _showing;
		}
		
		/**
		 * 设置 / 获取 子节点的长度
		 */
		public function get numNotes():int
		{
			return noteVec.length;
		}
		
		public function set numNotes(value:int):void
		{
			noteVec.length = value;
		}
		
		///**
		 //* 设置 / 获取 当子节点为空时是否自动隐藏
		 //*/
		//public function get autoHideEmptyNote():Boolean
		//{
			//return _autoHideEmptyNote;
		//}
		//
		//public function set autoHideEmptyNote(value:Boolean):void
		//{
			//_autoHideEmptyNote = value;
		//}
		
		/**
		 * 设置 / 获取 当前图标
		 */
		public function get icon():BitmapData
		{
			return Bitmap(iconContainer.getChildAt(0)).bitmapData;
		}
		
		ELGFla function set icon(value:BitmapData):void
		{
			Bitmap(iconContainer.getChildAt(0)).bitmapData = value;
			iconContainer.y = (label.height - iconContainer.height) >> 1;
		}
		
		/**
		 * 设置 / 获取 父级节点
		 */
		public function get parentNote():Tree
		{
			return _parentNote;
		}
		
		ELGFla function set parentNote(value:Tree):void
		{
			_parentNote = value;
		}
	
	}

}