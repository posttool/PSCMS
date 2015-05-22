package com.pagesociety.cms.sitemap
{
	import com.pagesociety.persistence.Entity;
	import com.pagesociety.ux.component.Container;
	import com.pagesociety.ux.component.Tree;
	import com.pagesociety.ux.component.TreeNode;
	import com.pagesociety.ux.event.DragAndDropTreeNodeEvent;

	public class CmsTree extends Tree
	{
		public function CmsTree(parent:Container)
		{
			super(parent);
			treeDecorator.lineColor = 0x444444;
			treeDecorator.lineAlpha = .5;
			cellRenderer = create_tree_node;
		}
		
		public function addNode(o:Object):TreeNode
		{
			var t:TreeNode = create_view(o);
			selectedNode.addChildNode(t);
			return t;
		}
		
		public function setNodeSize(w:Number, h:Number):void
		{
			treeLayout.cellHeight = h*1.5;
			for (var i:uint=0; i<children.length; i++)
			{
				children[i].width = w;
				children[i].height = h;
			}
		}
		
		public function setFontStyle(s:String):void
		{
			for (var i:uint=0; i<children.length; i++)
			{
				children[i].label.fontStyle = s;
			}
		}
		
		override protected function transform_drag_op(o:DragAndDropTreeNodeEvent):DragAndDropTreeNodeEvent
		{
			o = super.transform_drag_op(o);
			switch (o.subtype)
			{
				case DragAndDropTreeNodeEvent.DROP_LAST: //postera trees have a + as the last element
					o.cancel();
					break;
			}
			return o;
		}
		
		override protected function _drop(n:TreeNode, b:Boolean):void
		{
			n.selected = b;
			n.y -= 10 *(b?1:-1);
			n.render();
		}
		
		override protected function _nudge(left:TreeNode,right:TreeNode, b:Boolean):void
		{
			if(left!=null)
			{
				left.x -= 10 *(b?1:-1);
				render_node(left);
			}
			if(right!=null)
			{
				right.x += 10 *(b?1:-1);
				render_node(right);
			}
		}
		
		
		public function create_tree_node(parent:Container, e:Entity):TreeNode
		{
			var p:CmsTreeNode = new CmsTreeNode(parent, e);
			p.decorator.setDragComponent(p);
			p.decorator.addDropComponent(this);
//			if (_browser!=null)
//				p.decorator.addDropComponent(_browser);
			p.addEventListener(CmsTreeNode.DELETE_NODE, onBubbleEvent);
			return p;
		}
		
		
		
		override protected function create_view(o:Object):TreeNode
		{
			var n:TreeNode = super.create_view(o);
			if (o.$.data==null)
			{
				Logger.error("NO DATA FOR TreeNode "+o.toStringLong());
			}
//			else if (o.$.data.type == PosteraUserCMS.LANDINGPAGE_ENTITY)
//			{
				var b:CmsTreeNodeAdd = new CmsTreeNodeAdd(this);
				if (getTreeSize()>7) // will only add the tool tip if it appears early in building the tree
					b.tooltip = null;
				n.addChildNode(b);
//			}
			return n;
		}
		
		private function get_node_by_entity(tn:TreeNode, e:Entity):TreeNode
		{
			if (tn.userObject==null)
				return null;
			var data:Entity = tn.userObject.$.data;
			if (data.type == e.type && data.id.longValue == e.id.longValue)
				return tn;
			for (var i:uint; i<tn.childNodes.length; i++)
			{
				var g:TreeNode = get_node_by_entity(tn.childNodes[i],e);
				if (g!=null)
					return g;
			}
			return null;
		}
		
		public function getNodeByEntity(e:Entity):TreeNode
		{
			return get_node_by_entity(rootNode, e);
		}
		
		
	}
}