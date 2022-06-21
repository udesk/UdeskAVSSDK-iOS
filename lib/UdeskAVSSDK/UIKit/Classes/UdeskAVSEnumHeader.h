//
//  UdeskAVSEnumHeader.h
//  UdeskAVSSDK
//
//  Created by Admin on 2022/3/30.
//

#ifndef UdeskAVSEnumHeader_h
#define UdeskAVSEnumHeader_h


typedef NS_ENUM(NSUInteger, UDESK_VIDEO_TOOL_ACTION_TYPE) {
    UDESK_VIDEO_TOOL_ACTION_TYPE_ZOOM = 1,
    UDESK_VIDEO_TOOL_ACTION_TYPE_INFO,
    UDESK_VIDEO_TOOL_ACTION_TYPE_MICRO,
    UDESK_VIDEO_TOOL_ACTION_TYPE_EXCHANGE,
    UDESK_VIDEO_TOOL_ACTION_TYPE_TRANSFER,
    UDESK_VIDEO_TOOL_ACTION_TYPE_HANDOFF,
    UDESK_VIDEO_TOOL_ACTION_TYPE_ENABLE_VIDEO,
    UDESK_VIDEO_TOOL_ACTION_TYPE_SHARE_VIEW
};

typedef NS_ENUM(NSUInteger, UDESK_AVS_VIDEO_MODE) {
    UDESK_AVS_VIDEO_MODE_VIDEO_FULLSCREEN = 1,
    UDESK_AVS_VIDEO_MODE_VIDEO_SMALL,
    UDESK_AVS_VIDEO_MODE_VOICE
};

typedef NS_ENUM(NSUInteger, UDESK_AVS_FACE_MODE) {
    UDESK_AVS_FACE_MODE_MAIN = 1,
    UDESK_AVS_FACE_MODE_d,
};




//字段类型
typedef NS_ENUM(NSUInteger, UDFieldType) {
    UDFieldTypeCustomer = 0,        //客户字段
    UDFieldTypeTicket,            //工单字段
    UDFieldTypeCustom,             //自定义字段
    UDFieldTypeOrganization,        //公司字段
    UDFieldTypeTemplate,        //模版
    UDFieldTypeBusiness,        //业务记录
    UDFieldTypeAlarms,        //回访
};

//字段编辑类型
typedef NS_ENUM(NSUInteger, UDFieldEditType) {
    UDFieldEditTypeSelectBox = 0,        //选择字段
    UDFieldEditTypeTextField,           //编辑字段
};

//用户字段类型
typedef NS_ENUM(NSUInteger, UDCustomerFieldType) {
    UDCustomerFieldTypeName = 0,       //名字
    UDCustomerFieldTypeLevel,          //等级
    UDCustomerFieldTypeDescription,    //描述
    UDCustomerFieldTypeOrganization,   //公司
    UDCustomerFieldTypeCellPhone,      //手机
    UDCustomerFieldTypeEmail,          //邮箱
    UDCustomerFieldTypeTags,           //标签
    UDCustomerFieldTypeOwner,          //负责人
    UDCustomerFieldTypeOwnerGroup,     //负责组
    UDCustomerFieldTypeDetail,         //客户详情（呼叫中心弹屏需要）
};

//自定义字段类型
typedef NS_ENUM(NSUInteger, UDCustomFieldType) {
    UDCustomFieldTypeDroplist = 0,    //下拉框
    UDCustomFieldTypeRadio,           //单选框
    UDCustomFieldTypeCheckbox,        //多选框
    UDCustomFieldTypeChainedDroplist, //及联
    UDCustomFieldTypeLink,            //链接
    UDCustomFieldTypeText,            //文本
    UDCustomFieldTypeAreaText,        //多行文本
    UDCustomFieldTypeDate,            //日期
    UDCustomFieldTypeTime,            //事件
    UDCustomFieldTypeNumeric,         //数值
    UDCustomFieldTypeNumber,          //整数
    UDCustomFieldTypeLocation,        //地理位置
    UDCustomFieldTypeCellphone,       //手机号（前端自己匹配《单行文本、正整数、多行文本》出来的）
    UDCustomFieldTypeDataTime,       //日期时间
};

//im业务记录
typedef NS_ENUM(NSUInteger, UDBusinessFieldType) {
    UDBusinessFieldTypeIMSubject = 0,       //im业务记录主题
    UDBusinessFieldTypeCallCenterSubject,   //呼叫中心业务记录主题
};

//工单字段类型
typedef NS_ENUM(NSUInteger, UDTicketFieldType) {
    UDTicketFieldTypeSubject = 0,    //工单标题
    UDTicketFieldTypeContent,        //工单内容 (包括附件)
    UDTicketFieldTypeFollow,         //工单关注者
    UDTicketFieldTypeStatus,         //工单状态
    UDTicketFieldTypePriority,       //工单优先级
    UDTicketFieldTypeCustomer,       //工单客户
    UDTicketFieldTypeAssignee,       //工单客服
    UDTicketFieldTypeAssigneeGroup,  //工单客服组
    UDTicketFieldTypeTags,           //工单标签
    UDTicketFieldTypeSatisfaction,   //工单满意度
    UDTicketFieldTypeCreator,        //工单创建人
    UDTicketFieldTypeOrganization,   //工单客户公司
    UDTicketFieldTypeTimer,          //工单处理时间
    UDTicketFieldTypeNum,            //工单编号
    UDTicketFieldTypeCreatedAt,      //工单创建时间
    UDTicketFieldTypePlatform,       //工单渠道
    UDTicketFieldTypeAgentAndGroup,  //工单客服和客服组
};

//公司字段类型
typedef NS_ENUM(NSUInteger, UDOrganizationFieldType) {
    UDOrganizationFieldTypeName = 0,    //公司名称
    UDOrganizationFieldTypeDomain,      //公司域名
    UDOrganizationFieldTypeDescription, //公司描述
};

//回访字段类型
typedef NS_ENUM(NSUInteger, UDCallAlarmsFieldType) {
    UDCallAlarmsFieldTypeDateTime = 0, //回访日期时间
    UDCallAlarmsFieldTypeRemark,   //回防备注
    UDCallAlarmsFieldTypeNickName,   //回防客户名称
    UDCallAlarmsFieldTypeCellPhone,   //回防客户联系方式
    UDCallAlarmsFieldTypeResult,   //回防结果
};



#endif /* UdeskAVSEnumHeader_h */
