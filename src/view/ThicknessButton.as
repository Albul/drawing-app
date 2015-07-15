/**
 * Copyright (c) 2011-2012 Alexandr Albul
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package view {
import flash.display.Bitmap;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.geom.Point;

public class ThicknessButton extends Sprite {

	//--------------------------------------
	//  Embedded icons
	//--------------------------------------

	[Embed(source='../../assets/line1.png')] private static const IcSmallLine:Class;
	[Embed(source='../../assets/line2.png')] private static const IcMediumLine:Class;
	[Embed(source='../../assets/line3.png')] private static const IcLargeLine:Class;

	//--------------------------------------
	//  Private members
	//--------------------------------------

	private var _mainButton:Sprite;
	private var _mainBmp:Bitmap;
	private var _dropRightPanel:Sprite;
	private var _thickSmallButton:Sprite;
	private var _thickMediumButton:Sprite;
	private var _thickLargeButton:Sprite;

	//--------------------------------------------------------------------------
	//
	//  Public methods
	//
	//--------------------------------------------------------------------------

	public function ThicknessButton() {
	}

	public function init():void {
		_mainButton = new Sprite();
		_mainButton.buttonMode = true;
		_mainBmp = new Bitmap(new IcSmallLine().bitmapData);
		_mainButton.addChild(_mainBmp);
		addChild(_mainButton);
		_mainButton.addEventListener(MouseEvent.CLICK, mainButton_clickHandler);

		_dropRightPanel = new Sprite();
		_dropRightPanel.x = _mainButton.width;

		// Button small thickness
		_thickSmallButton = new Sprite();
		_thickSmallButton.buttonMode = true;
		var smallBmp:Bitmap = new Bitmap(new IcSmallLine().bitmapData);
		_thickSmallButton.addChild(smallBmp);
		_thickSmallButton.x = 0;
		_dropRightPanel.addChild(_thickSmallButton);
		_thickSmallButton.addEventListener(MouseEvent.CLICK, thickButton_clickHandler);

		// Button medium thickness
		_thickMediumButton = new Sprite();
		_thickMediumButton.buttonMode = true;
		var mediumBmp:Bitmap = new Bitmap(new IcMediumLine().bitmapData);
		_thickMediumButton.addChild(mediumBmp);
		_thickMediumButton.x = _thickSmallButton.width;
		_dropRightPanel.addChild(_thickMediumButton);
		_thickMediumButton.addEventListener(MouseEvent.CLICK, thickButton_clickHandler);

		// Button large thickness
		_thickLargeButton = new Sprite();
		_thickLargeButton.buttonMode = true;
		var largeBmp:Bitmap = new Bitmap(new IcLargeLine().bitmapData);
		_thickLargeButton.addChild(largeBmp);
		_thickLargeButton.x = _thickMediumButton.x + _thickMediumButton.width;
		_dropRightPanel.addChild(_thickLargeButton);
		_thickLargeButton.addEventListener(MouseEvent.CLICK, thickButton_clickHandler);

		_dropRightPanel.x = ToolPanel.TOOL_PANEL_WIDTH;
		_dropRightPanel.y = parent.localToGlobal(new Point(x, y)).y;
		_dropRightPanel.graphics.beginFill(Constants.PANEL_COLOR);
		_dropRightPanel.graphics.drawRect(0, 0, _dropRightPanel.width, _dropRightPanel.height);
		_dropRightPanel.graphics.endFill();
	}

	//--------------------------------------------------------------------------
	//
	//  Event handlers
	//
	//--------------------------------------------------------------------------

	private function mainButton_clickHandler(event:MouseEvent):void {
		if (stage.contains(_dropRightPanel)) {
			stage.removeChild(_dropRightPanel);
		} else {
			stage.addChild(_dropRightPanel);
		}
	}

	private function thickButton_clickHandler(event:MouseEvent):void {
		var thickness:int;
		_mainButton.removeChild(_mainBmp);
		if (event.currentTarget == _thickSmallButton) {
			thickness = Constants.SMALL;
			_mainBmp = new Bitmap(new IcSmallLine().bitmapData);
		} else if (event.currentTarget == _thickMediumButton) {
			thickness = Constants.MEDIUM;
			_mainBmp = new Bitmap(new IcMediumLine().bitmapData);
		} else if (event.currentTarget == _thickLargeButton) {
			thickness = Constants.LARGE;
			_mainBmp = new Bitmap(new IcLargeLine().bitmapData);
		}
		_mainButton.addChild(_mainBmp);
		if (stage.contains(_dropRightPanel)) {
			stage.removeChild(_dropRightPanel);
		}
		dispatchEvent(new ToolEvent(ToolEvent.THICKNESS_CHANGED, -1, thickness));
	}
}
}
