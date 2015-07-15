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
package {
import flash.display.BitmapData;
import flash.display.CapsStyle;
import flash.display.JointStyle;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.net.FileReference;
import flash.utils.ByteArray;

import utils.MathUtils;

import utils.PNGEncoder;

import view.ToolPanel;

public class DrawingController {

	//--------------------------------------
	//  Private members
	//--------------------------------------

	private var _currentTool:int = Constants.INVALID_TOOL;
	private var _currentColor:uint = Constants.BLACK_COLOR;
	private var _currentAlpha:Number = 1;
	private var _currentThickness:int = Constants.SMALL;
	private var _currentLayer:Shape;
	private var _board:Sprite;

	private var _startX:Number;
	private var _startY:Number;

	public function DrawingController(toolPanel:ToolPanel, board:Sprite) {
		_board = board;
		toolPanel.addEventListener(ToolEvent.TOOL_SELECTED, toolSelectedHandler);
		toolPanel.addEventListener(ToolEvent.SAVE_CLICKED, saveClickedHandler);
		toolPanel.addEventListener(ToolEvent.TRASH_CLICKED, trashClickedHandler);
		toolPanel.addEventListener(ToolEvent.THICKNESS_CHANGED, thicknessChangedHandler);
		toolPanel.addEventListener(ToolEvent.COLOR_CHANGED, colorChangedHandler);
		_board.addEventListener(MouseEvent.MOUSE_DOWN, board_mouseDownHandler);
		_board.stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
	}

	//--------------------------------------------------------------------------
	//
	//  Event handlers
	//
	//--------------------------------------------------------------------------

	private function board_mouseDownHandler(event:MouseEvent):void {
		switch (_currentTool) {
			case Constants.PENCIL_TOOL:
				startPencilTool();
				break;
			case Constants.RECT_TOOL:
				startRectTool();
				break;
			case Constants.ELLIPSE_TOOL:
				startEllipseTool();
				break;
			case Constants.ERASER_TOOL:
				startEraserTool();
				break;
		}
	}

	private function mouseUpHandler(event:MouseEvent):void {
		switch (_currentTool) {
			case Constants.PENCIL_TOOL:
				stopPencilTool();
				break;
			case Constants.RECT_TOOL:
				stopRectTool();
				break;
			case Constants.ELLIPSE_TOOL:
				stopEllipseTool();
				break;
			case Constants.ERASER_TOOL:
				stopEraserTool();
				break;
		}
	}

	private function toolSelectedHandler(event:ToolEvent):void {
		_currentTool = event.tool;
	}

	private function saveClickedHandler(event:ToolEvent):void {
		var bmd:BitmapData = new BitmapData(_board.width, _board.height);
		bmd.draw(_board);
		var ba:ByteArray = PNGEncoder.encode(bmd);
		var fileRef:FileReference = new FileReference();
		fileRef.save(ba, "UnnamedImage.png");
	}

	private function trashClickedHandler(event:ToolEvent):void {
		while (_board.numChildren > 0) {
			_board.removeChildAt(0);
		}
	}

	private function thicknessChangedHandler(event:ToolEvent):void {
		_currentThickness = event.thickness;
	}

	private function colorChangedHandler(event:ToolEvent):void {
		_currentColor = event.color;
		_currentAlpha = event.alpha;
	}

	//--------------------------------------------------------------------------
	//
	//  Drawing methods
	//
	//--------------------------------------------------------------------------

	// Pencil
	private function startPencilTool():void {
		_currentLayer = new Shape();
		_board.addChild(_currentLayer);

		_currentLayer.graphics.lineStyle(_currentThickness, _currentColor, _currentAlpha, false, "normal",
				CapsStyle.ROUND, JointStyle.ROUND);
		_currentLayer.graphics.moveTo(_board.mouseX, _board.mouseY);

		_board.addEventListener(MouseEvent.MOUSE_MOVE, drawPencilTool);
	}

	private function drawPencilTool(event:MouseEvent):void {
		_currentLayer.graphics.lineTo(_board.mouseX, _board.mouseY);
	}

	private function stopPencilTool():void {
		_board.removeEventListener(MouseEvent.MOUSE_MOVE, drawPencilTool);
	}

	// Rect
	private function startRectTool():void {
		_currentLayer = new Shape();
		_board.addChild(_currentLayer);

		_startX = _board.mouseX;
		_startY = _board.mouseY;
		_currentLayer.graphics.lineStyle(_currentThickness, _currentColor, _currentAlpha);
		_currentLayer.graphics.drawRect(_startX, _startY, 2, 2);

		_board.addEventListener(MouseEvent.MOUSE_MOVE, drawRectTool);
	}

	private function drawRectTool(event:MouseEvent):void {
		_currentLayer.graphics.clear();
		_currentLayer.graphics.lineStyle(_currentThickness, _currentColor, _currentAlpha);
		var rectWidth:Number = _board.mouseX - _startX;
		var rectHeight:Number = _board.mouseY - _startY;

		// Proportional scaling
		if (event.ctrlKey) {
			var widthSign:int = MathUtils.sign(rectWidth);
			var heightSign:int = MathUtils.sign(rectHeight);
			rectWidth = rectHeight = Math.min(Math.abs(rectWidth), Math.abs(rectHeight));
			rectWidth *= widthSign;
			rectHeight *= heightSign;
		}
		_currentLayer.graphics.drawRect(_startX, _startY, rectWidth, rectHeight);
	}

	private function stopRectTool():void {
		_board.removeEventListener(MouseEvent.MOUSE_MOVE, drawRectTool);
	}

	// Ellipse
	private function startEllipseTool():void {
		_currentLayer = new Shape();
		_board.addChild(_currentLayer);

		_startX = _board.mouseX;
		_startY = _board.mouseY;
		_currentLayer.graphics.lineStyle(_currentThickness, _currentColor, _currentAlpha);
		_currentLayer.graphics.drawEllipse(_startX, _startY, 2, 2);

		_board.addEventListener(MouseEvent.MOUSE_MOVE, drawEllipseTool);
	}

	private function drawEllipseTool(event:MouseEvent):void {
		_currentLayer.graphics.clear();
		_currentLayer.graphics.lineStyle(_currentThickness, _currentColor, _currentAlpha);
		var ellipseWidth:Number = _board.mouseX - _startX;
		var ellipseHeight:Number = _board.mouseY - _startY;

		// Proportional scaling
		if (event.ctrlKey) {
			var widthSign:int = MathUtils.sign(ellipseWidth);
			var heightSign:int = MathUtils.sign(ellipseHeight);
			ellipseWidth = ellipseHeight = Math.min(Math.abs(ellipseWidth), Math.abs(ellipseHeight));
			ellipseWidth *= widthSign;
			ellipseHeight *= heightSign;
		}
		_currentLayer.graphics.drawEllipse(_startX, _startY, ellipseWidth, ellipseHeight);
	}

	private function stopEllipseTool():void {
		_board.removeEventListener(MouseEvent.MOUSE_MOVE, drawEllipseTool);
	}

	// Eraser
	private function startEraserTool():void {
		_currentLayer = new Shape();
		_board.addChild(_currentLayer);

		_currentLayer.graphics.lineStyle(Constants.ERASER_SIZE, Constants.WHITE_COLOR);
		_currentLayer.graphics.moveTo(_board.mouseX, _board.mouseY);

		_board.addEventListener(MouseEvent.MOUSE_MOVE, drawEraserTool);
	}

	private function drawEraserTool(event:MouseEvent):void {
		_currentLayer.graphics.lineTo(_board.mouseX, _board.mouseY);
	}

	private function stopEraserTool():void {
		_board.removeEventListener(MouseEvent.MOUSE_MOVE, drawEraserTool);
	}
}
}
