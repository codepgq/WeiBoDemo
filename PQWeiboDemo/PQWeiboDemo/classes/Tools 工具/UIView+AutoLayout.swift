//
//  UIView+AutoLayout.swift
//  pqWeibo
//
//  Created by 李南江 on 15/9/1.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

import UIKit
/**
 对齐类型枚举，设置控件相对于父视图的位置
 - TopLeft:      左上
 - TopRight:     右上
 - TopCenter:    中上
 - BottomLeft:   左下
 - BottomRight:  右下
 - BottomCenter: 中下
 - CenterLeft:   左中
 - CenterRight:  右中
 - Center: 中中
 */
public enum pq_AlignType {
    case TopLeft
    case TopRight
    case TopCenter
    case BottomLeft
    case BottomRight
    case BottomCenter
    case CenterLeft
    case CenterRight
    case Center
    
    fileprivate func layoutAttributes(isInner: Bool, isVertical: Bool) -> pq_LayoutAttributes {
        let attributes = pq_LayoutAttributes()
        
        switch self {
        case .TopLeft:
            attributes.horizontals(from: .left, to: .left).verticals(from: .top, to: .top)
            
            if isInner {
                return attributes
            } else if isVertical {
                return attributes.verticals(from: .bottom, to: .top)
            } else {
                return attributes.horizontals(from: .right, to: .left)
            }
        case .TopRight:
            attributes.horizontals(from: .right, to: .right).verticals(from : .top, to: .top)
            
            if isInner {
                return attributes
            } else if isVertical {
                return attributes.verticals(from: .bottom, to: .top)
            } else {
                return attributes.horizontals(from: .left, to: .right)
            }
        case .BottomLeft:
            attributes.horizontals(from: .left, to: .left).verticals(from : .bottom, to: .bottom)
            
            if isInner {
                return attributes
            } else if isVertical {
                return attributes.verticals(from: .top, to: .bottom)
            } else {
                return attributes.horizontals(from: .right, to: .left)
            }
        case .BottomRight:
            attributes.horizontals(from: .right, to: .right).verticals(from : .bottom, to: .bottom)
            
            if isInner {
                return attributes
            } else if isVertical {
                return attributes.verticals(from: .top, to: .bottom)
            } else {
                return attributes.horizontals(from: .left, to: .right)
            }
        // 仅内部 & 垂直参照需要
        case .TopCenter:
            attributes.horizontals(from: .centerX, to: .centerX).verticals(from : .top, to: .top)
            return isInner ? attributes : attributes.verticals(from: .bottom, to: .top)
        // 仅内部 & 垂直参照需要
        case .BottomCenter:
            attributes.horizontals(from: .centerX, to: .centerX).verticals(from : .bottom, to: .bottom)
            return isInner ? attributes : attributes.verticals(from: .top, to: .bottom)
        // 仅内部 & 水平参照需要
        case .CenterLeft:
            attributes.horizontals(from: .left, to: .left).verticals(from : .centerY, to: .centerY)
            return isInner ? attributes : attributes.horizontals(from: .right, to: .left)
        // 仅内部 & 水平参照需要
        case .CenterRight:
            attributes.horizontals(from: .right, to: .right).verticals(from : .centerY, to: .centerY)
            return isInner ? attributes : attributes.horizontals(from: .left, to: .right)
        // 仅内部参照需要
        case .Center:
            return pq_LayoutAttributes(horizontal: .centerX, referHorizontal: .centerX, vertical: .centerY, referVertical: .centerY)
        }
    }
}

extension UIView {
    
    
    /**
     填充子视图
     
     :param: referView 参考视图
     :param: insets    间距
     
     :returns: 约束数组
     */
    @discardableResult public func pq_fill(referView: UIView, insets: UIEdgeInsets = UIEdgeInsets.zero) -> [NSLayoutConstraint] {
        translatesAutoresizingMaskIntoConstraints = false
        
        var cons = [NSLayoutConstraint]()
        
        cons += NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(insets.left)-[subView]-\(insets.right)-|", options: NSLayoutFormatOptions.alignAllFirstBaseline, metrics: nil, views: ["subView" : self])
        cons += NSLayoutConstraint.constraints(withVisualFormat: "V:|-\(insets.top)-[subView]-\(insets.bottom)-|", options: NSLayoutFormatOptions.alignAllFirstBaseline, metrics: nil, views: ["subView" : self])
        
        superview?.addConstraints(cons)
        
        return cons
    }
    
    /**
     参照参考视图内部对齐
     
     :param: type      对齐方式
     :param: referView 参考视图
     :param: size      视图大小，如果是 nil 则不设置大小
     :param: offset    偏移量，默认是 CGPoint(x: 0, y: 0)
     
     :returns: 约束数组
     */
    @discardableResult public func pq_AlignInner(type: pq_AlignType, referView: UIView, size: CGSize?, offset: CGPoint = CGPoint.zero) -> [NSLayoutConstraint]  {
        
        return pq_AlignLayout(referView: referView, attributes: type.layoutAttributes(isInner: true, isVertical: true), size: size, offset: offset)
    }
    
    /**
     参照参考视图垂直对齐
     
     :param: type      对齐方式
     :param: referView 参考视图
     :param: size      视图大小，如果是 nil 则不设置大小
     :param: offset    偏移量，默认是 CGPoint(x: 0, y: 0)
     
     :returns: 约束数组
     */
    @discardableResult public func pq_AlignVertical(type: pq_AlignType, referView: UIView, size: CGSize?, offset: CGPoint = CGPoint.zero) -> [NSLayoutConstraint] {
        
        return pq_AlignLayout(referView: referView, attributes: type.layoutAttributes(isInner: false, isVertical: true), size: size, offset: offset)
    }
    
    /**
     参照参考视图水平对齐
     
     :param: type      对齐方式
     :param: referView 参考视图
     :param: size      视图大小，如果是 nil 则不设置大小
     :param: offset    偏移量，默认是 CGPoint(x: 0, y: 0)
     
     :returns: 约束数组
     */
    @discardableResult public func pq_AlignHorizontal(type: pq_AlignType, referView: UIView, size: CGSize?, offset: CGPoint = CGPoint.zero) -> [NSLayoutConstraint] {
        
        return pq_AlignLayout(referView: referView, attributes: type.layoutAttributes(isInner: false, isVertical: false), size: size, offset: offset)
    }
    
    /**
     在当前视图内部水平平铺控件
     
     :param: views  子视图数组
     :param: insets 间距
     
     :returns: 约束数组
     */
    @discardableResult public func pq_HorizontalTile(views: [UIView], insets: UIEdgeInsets) -> [NSLayoutConstraint] {
        
        assert(!views.isEmpty, "views should not be empty")
        
        var cons = [NSLayoutConstraint]()
        
        let firstView = views[0]
        firstView.pq_AlignInner(type: pq_AlignType.TopLeft, referView: self, size: nil, offset: CGPoint(x: insets.left, y: insets.top))
        cons.append(NSLayoutConstraint(item: firstView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: -insets.bottom))
        
        // 添加后续视图的约束
        var preView = firstView
        for i in 1..<views.count {
            let subView = views[i]
            cons += subView.pq_sizeConstraints(referView: firstView)
            subView.pq_AlignHorizontal(type: pq_AlignType.TopRight, referView: preView, size: nil, offset: CGPoint(x: insets.right, y: 0))
            preView = subView
        }
        
        let lastView = views.last!
        cons.append(NSLayoutConstraint(item: lastView, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.right, multiplier: 1.0, constant: -insets.right))
        
        addConstraints(cons)
        return cons
    }
    
    /**
     在当前视图内部垂直平铺控件
     
     :param: views  子视图数组
     :param: insets 间距
     
     :returns: 约束数组
     */
    @discardableResult public func pq_VerticalTile(views: [UIView], insets: UIEdgeInsets) -> [NSLayoutConstraint] {
        
        assert(!views.isEmpty, "views should not be empty")
        
        var cons = [NSLayoutConstraint]()
        
        let firstView = views[0]
        firstView.pq_AlignInner(type: pq_AlignType.TopLeft, referView: self, size: nil, offset: CGPoint(x: insets.left, y: insets.top))
        cons.append(NSLayoutConstraint(item: firstView, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.right, multiplier: 1.0, constant: -insets.right))
        
        // 添加后续视图的约束
        var preView = firstView
        for i in 1..<views.count {
            let subView = views[i]
            subView.pq_sizeConstraints(referView: firstView)
            //            cons += subView.pq_sizeConstraints( refirstView)
            subView.pq_AlignVertical(type: pq_AlignType.BottomLeft, referView: preView, size: nil, offset: CGPoint(x: 0, y: insets.bottom))
            preView = subView
        }
        
        let lastView = views.last!
        cons.append(NSLayoutConstraint(item: lastView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: -insets.bottom))
        
        addConstraints(cons)
        
        return cons
    }
    
    /**
     从约束数组中查找指定 attribute 的约束
     
     :param: constraintsList 约束数组
     :param: attribute       约束属性
     
     :returns: 对应的约束
     */
    public func pq_Constraint(constraintsList: [NSLayoutConstraint], attribute: NSLayoutAttribute) -> NSLayoutConstraint? {
       
        for constraint in constraintsList {
            if constraint.firstItem as! NSObject == self && constraint.firstAttribute == attribute {
                return constraint
            }
        }
        
        return nil
    }
    
    public func pq_ConstraintWidth(constraintsList: [NSLayoutConstraint]) -> NSLayoutConstraint? {
        return pq_Constraint(constraintsList: constraintsList, attribute: .width)
    }
    
    public func pq_ConstraintHeight(constraintsList: [NSLayoutConstraint]) -> NSLayoutConstraint? {
        return pq_Constraint(constraintsList: constraintsList, attribute: .height)
    }
    
    public func pq_ConstraintTop(constraintsList: [NSLayoutConstraint]) -> NSLayoutConstraint? {
        return pq_Constraint(constraintsList: constraintsList, attribute: .top)
    }
    
    
    
    // MARK: - 私有函数
    /**
     参照参考视图对齐布局
     
     :param: referView  参考视图
     :param: attributes 参照属性
     :param: size       视图大小，如果是 nil 则不设置大小
     :param: offset     偏移量，默认是 CGPoint(x: 0, y: 0)
     
     :returns: 约束数组
     */
    @discardableResult private func pq_AlignLayout(referView: UIView, attributes: pq_LayoutAttributes, size: CGSize?, offset: CGPoint) -> [NSLayoutConstraint] {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        var cons = [NSLayoutConstraint]()
        
        cons += pq_positionConstraints(referView: referView, attributes: attributes, offset: offset)
        
        if size != nil {
            cons += pq_sizeConstraints(size:size!)
        }
        
        superview?.addConstraints(cons)
        
        return cons
    }
    
    
    /**
     尺寸约束数组
     
     :param: size 视图大小
     
     :returns: 约束数组
     */
    @discardableResult private func pq_sizeConstraints(size: CGSize) -> [NSLayoutConstraint] {
        
        var cons = [NSLayoutConstraint]()
        
        cons.append(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0, constant: size.width))
        cons.append(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0, constant: size.height))
        
        return cons
    }
    
    
    /**
     尺寸约束数组
     
     :param: referView 参考视图，与参考视图大小一致
     
     :returns: 约束数组
     */
    @discardableResult private func pq_sizeConstraints(referView: UIView) -> [NSLayoutConstraint] {
        
        var cons = [NSLayoutConstraint]()
        
        cons.append(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: referView, attribute: NSLayoutAttribute.width, multiplier: 1.0, constant: 0))
        cons.append(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: referView, attribute: NSLayoutAttribute.height, multiplier: 1.0, constant: 0))
        
        return cons
    }
    
    /**
     位置约束数组
     
     :param: referView  参考视图
     :param: attributes 参照属性
     :param: offset     偏移量
     
     :returns: 约束数组
     */
    private func pq_positionConstraints(referView: UIView, attributes: pq_LayoutAttributes, offset: CGPoint) -> [NSLayoutConstraint] {
        
        var cons = [NSLayoutConstraint]()
        
        cons.append(NSLayoutConstraint(item: self, attribute: attributes.horizontal, relatedBy: NSLayoutRelation.equal, toItem: referView, attribute: attributes.referHorizontal, multiplier: 1.0, constant: offset.x))
        cons.append(NSLayoutConstraint(item: self, attribute: attributes.vertical, relatedBy: NSLayoutRelation.equal, toItem: referView, attribute: attributes.referVertical, multiplier: 1.0, constant: offset.y))
        
        return cons
    }
}

///  布局属性
private final class pq_LayoutAttributes {
    var horizontal:         NSLayoutAttribute
    var referHorizontal:    NSLayoutAttribute
    var vertical:           NSLayoutAttribute
    var referVertical:      NSLayoutAttribute
    
    init() {
        horizontal = NSLayoutAttribute.left
        referHorizontal = NSLayoutAttribute.left
        vertical = NSLayoutAttribute.top
        referVertical = NSLayoutAttribute.top
    }
    
    init( horizontal: NSLayoutAttribute, referHorizontal: NSLayoutAttribute, vertical: NSLayoutAttribute, referVertical: NSLayoutAttribute) {
        
        self.horizontal = horizontal
        self.referHorizontal = referHorizontal
        self.vertical = vertical
        self.referVertical = referVertical
    }
    
    @discardableResult func horizontals( from: NSLayoutAttribute, to: NSLayoutAttribute) -> Self {
        horizontal = from
        referHorizontal = to
        
        return self
    }
    
    @discardableResult func verticals( from: NSLayoutAttribute, to: NSLayoutAttribute) -> Self {
        vertical = from
        referVertical = to
        
        return self
    }
}
