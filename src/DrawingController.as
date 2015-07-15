/**
 * Created by abdula on 15.07.2015.
 */
package {
import flash.display.BitmapData;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.net.FileReference;
import flash.utils.ByteArray;

import utils.PNGEncoder;

public class DrawingController {

	private static const ERASER_SIZE:int = 10;

	//--------------------------------------
	//  Private members
	//--------------------------------------

	private var _currentTool:int = Constants.INVALID_TOOL;
	private var _currentColor:uint = Constants.BLACK_COLOR;
	private var _currentSize:int = 1;
	private var _currentLayer:Shape;
	private var _board:Sprite;

	private var startX:Number;
	private var startY:Number;

	public function DrawingController(toolPanel:ToolPanel, board:Sprite) {
		_board = board;
		toolPanel.addEventListener(ToolEvent.TOOL_SELECTED, toolSelectedHandler);
		toolPanel.addEventListener(ToolEvent.SAVE_CLICKED, saveClickedHandler);
		toolPanel.addEventListener(ToolEvent.TRASH_CLICKED, trashClickedHandler);
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

	//--------------------------------------------------------------------------
	//
	//  Drawing methods
	//
	//--------------------------------------------------------------------------

	// Pencil
	private function startPencilTool():void {
		_currentLayer = new Shape();
		_board.addChild(_currentLayer);

		_currentLayer.graphics.lineStyle(_currentSize, _currentColor);
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

		startX = _board.mouseX;
		startY = _board.mouseY;
		_currentLayer.graphics.lineStyle(_currentSize, _currentColor);
		_currentLayer.graphics.drawRect(startX, startY, 2, 2);

		_board.addEventListener(MouseEvent.MOUSE_MOVE, drawRectTool);
	}

	private function drawRectTool(event:MouseEvent):void {
		_currentLayer.graphics.clear();
		_currentLayer.graphics.lineStyle(_currentSize, _currentColor);
		_currentLayer.graphics.drawRect(startX, startY, _board.mouseX - startX, _board.mouseY - startY);
	}

	private function stopRectTool():void {
		_board.removeEventListener(MouseEvent.MOUSE_MOVE, drawRectTool);
	}

	// Eraser
	private function startEraserTool():void {
		_currentLayer = new Shape();
		_board.addChild(_currentLayer);

		_currentLayer.graphics.lineStyle(ERASER_SIZE, Constants.WHITE_COLOR);
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
