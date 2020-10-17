(window.webpackJsonp=window.webpackJsonp||[]).push([["chunk-7c6b"],{HMof:function(e,t,i){"use strict";i.r(t);var n=i("o0o1"),s=i.n(n),a=i("yXPU"),r=i.n(a),o=i("lSNA"),l=i.n(o),c=i("rIUS"),v=i("L2JU"),u=i("9i3r");function m(e,t){var i=Object.keys(e);if(Object.getOwnPropertySymbols){var n=Object.getOwnPropertySymbols(e);t&&(n=n.filter(function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable})),i.push.apply(i,n)}return i}function d(e){for(var t=1;t<arguments.length;t++){var i=null!=arguments[t]?arguments[t]:{};t%2?m(Object(i),!0).forEach(function(t){l()(e,t,i[t])}):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(i)):m(Object(i)).forEach(function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(i,t))})}return e}var p={components:{RebootButton:c.a},data:function(){return{rules:{email:[{validator:this.validateEmail,trigger:"blur"}]},newTokenForm:{maxUse:1,expiresAt:""},inviteUserForm:{email:"",name:""},createTokenDialogVisible:!1,inviteUserDialogVisible:!1}},computed:d(d({},Object(v.b)(["authHost"])),{},{getLabelWidth:function(){return this.isDesktop?"100px":"85px"},inviteLink:function(){return"".concat(Object(u.a)(this.authHost),"/registration/").concat(this.newToken.token)},isDesktop:function(){return"desktop"===this.$store.state.app.device},loading:function(){return this.$store.state.invites.loading},newToken:function(){return this.$store.state.invites.newToken},tokens:function(){return this.$store.state.invites.inviteTokens}}),mounted:function(){this.$store.dispatch("GetNodeInfo"),this.$store.dispatch("NeedReboot"),this.$store.dispatch("FetchInviteTokens")},methods:{closeDialogWindow:function(){this.inviteUserDialogVisible=!1,this.createTokenDialogVisible=!1,this.$store.dispatch("RemoveNewToken"),this.$data.inviteUserForm.email="",this.$data.inviteUserForm.name=""},createToken:function(){this.$store.dispatch("GenerateInviteToken",this.$data.newTokenForm)},inviteUserViaEmail:function(){var e=this;return r()(s.a.mark(function t(){return s.a.wrap(function(t){for(;;)switch(t.prev=t.next){case 0:e.$refs.inviteUserForm.validate(function(){var t=r()(s.a.mark(function t(i){return s.a.wrap(function(t){for(;;)switch(t.prev=t.next){case 0:if(!i){t.next=6;break}return t.next=3,e.$store.dispatch("InviteUserViaEmail",e.$data.inviteUserForm);case 3:e.closeDialogWindow(),t.next=8;break;case 6:return e.$message({type:"error",message:e.$t("invites.submitFormError")}),t.abrupt("return",!1);case 8:case"end":return t.stop()}},t)}));return function(e){return t.apply(this,arguments)}}());case 1:case"end":return t.stop()}},t)}))()},revokeInviteToken:function(e){this.$store.dispatch("RevokeToken",e)},validateEmail:function(e,t,i){return""===t?i(new Error(this.$t("invites.emptyEmailError"))):this.validEmail(t)?i():i(new Error(this.$t("invites.invalidEmailError")))},validEmail:function(e){return/^[a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$/.test(e)}}},b=(i("ObxI"),i("KHd+")),k=Object(b.a)(p,function(){var e=this,t=e.$createElement,i=e._self._c||t;return i("div",{staticClass:"invites-container"},[i("div",{staticClass:"invites-header-container"},[i("h1",[e._v(e._s(e.$t("invites.inviteTokens")))]),e._v(" "),i("reboot-button")],1),e._v(" "),i("div",{staticClass:"actions-container"},[i("el-button",{staticClass:"create-invite-token",on:{click:function(t){e.createTokenDialogVisible=!0}}},[i("span",[i("i",{staticClass:"icon el-icon-plus"}),e._v("\n        "+e._s(e.$t("invites.createInviteToken"))+"\n      ")])]),e._v(" "),i("el-button",{staticClass:"invite-via-email",on:{click:function(t){e.inviteUserDialogVisible=!0}}},[i("span",[i("i",{staticClass:"icon el-icon-message"}),e._v("\n        "+e._s(e.$t("invites.inviteUserViaEmail"))+"\n      ")])])],1),e._v(" "),i("el-dialog",{attrs:{visible:e.createTokenDialogVisible,"show-close":!1,title:e.$t("invites.createInviteToken"),"custom-class":"create-new-token-dialog"},on:{"update:visible":function(t){e.createTokenDialogVisible=t}}},[i("el-form",{ref:"newTokenForm",attrs:{model:e.newTokenForm,"label-width":e.getLabelWidth,"status-icon":""}},[i("el-form-item",{attrs:{label:e.$t("invites.maxUse")}},[i("el-input-number",{attrs:{min:0,size:e.isDesktop?"medium":"small",name:"maxUse"},model:{value:e.newTokenForm.maxUse,callback:function(t){e.$set(e.newTokenForm,"maxUse",t)},expression:"newTokenForm.maxUse"}})],1),e._v(" "),i("el-form-item",{attrs:{label:e.$t("invites.expiresAt")}},[i("el-date-picker",{staticClass:"pick-date",attrs:{placeholder:e.$t("invites.pickDate"),type:"date",name:"date","value-format":"yyyy-MM-dd"},model:{value:e.newTokenForm.expiresAt,callback:function(t){e.$set(e.newTokenForm,"expiresAt",t)},expression:"newTokenForm.expiresAt"}})],1)],1),e._v(" "),i("span",{attrs:{slot:"footer"},slot:"footer"},[i("el-button",{staticClass:"invites-close-dialog",on:{click:e.closeDialogWindow}},[e._v(e._s(e.$t("invites.cancel")))]),e._v(" "),i("el-button",{attrs:{type:"primary"},on:{click:e.createToken}},[e._v(e._s(e.$t("invites.create")))])],1),e._v(" "),"token"in e.newToken?i("el-card",[i("div",{staticClass:"clearfix",attrs:{slot:"header"},slot:"header"},[i("span",[e._v(e._s(e.$t("invites.tokenCreated")))])]),e._v(" "),i("el-form",{staticClass:"new-token-card",attrs:{"label-width":"85px"}},[i("el-form-item",{attrs:{label:e.$t("invites.inviteLink")}},[i("el-link",{attrs:{href:e.inviteLink,underline:!1,target:"_blank"}},[e._v("\n            "+e._s(e.inviteLink)+"\n          ")])],1),e._v(" "),i("el-form-item",{attrs:{label:e.$t("invites.token")}},[e._v("\n          "+e._s(e.newToken.token)+"\n        ")]),e._v(" "),i("el-form-item",{attrs:{label:e.$t("invites.maxUse")}},[e._v("\n          "+e._s(e.newToken.maxUse)+"\n        ")]),e._v(" "),i("el-form-item",{attrs:{label:e.$t("invites.expiresAt")}},[e._v("\n          "+e._s(e.newToken.expiresAt||"(not set)")+"\n        ")])],1)],1):e._e()],1),e._v(" "),i("el-dialog",{attrs:{visible:e.inviteUserDialogVisible,"show-close":!1,title:e.$t("invites.sendRegistration"),"custom-class":"invite-via-email-dialog"},on:{"update:visible":function(t){e.inviteUserDialogVisible=t}}},[i("div",[i("p",{staticClass:"info"},[e._v(e._s(e.$t("invites.inviteViaEmailAlert")))]),e._v(" "),i("el-form",{ref:"inviteUserForm",attrs:{model:e.inviteUserForm,rules:e.rules,"label-width":e.getLabelWidth,"status-icon":""}},[i("el-form-item",{attrs:{label:e.$t("invites.email"),prop:"email"}},[i("el-input",{attrs:{name:"email",type:"email",autofocus:""},model:{value:e.inviteUserForm.email,callback:function(t){e.$set(e.inviteUserForm,"email",t)},expression:"inviteUserForm.email"}})],1),e._v(" "),i("el-form-item",{attrs:{label:e.$t("invites.name"),prop:"name"}},[i("el-input",{attrs:{name:"name"},model:{value:e.inviteUserForm.name,callback:function(t){e.$set(e.inviteUserForm,"name",t)},expression:"inviteUserForm.name"}})],1)],1)],1),e._v(" "),i("span",{attrs:{slot:"footer"},slot:"footer"},[i("el-button",{on:{click:e.closeDialogWindow}},[e._v(e._s(e.$t("invites.cancel")))]),e._v(" "),i("el-button",{attrs:{type:"primary"},on:{click:e.inviteUserViaEmail}},[e._v(e._s(e.$t("invites.create")))])],1)]),e._v(" "),i("el-table",{directives:[{name:"loading",rawName:"v-loading",value:e.loading,expression:"loading"}],staticClass:"invite-token-table",attrs:{data:e.tokens,"default-sort":{prop:"used",order:"ascending"}}},[e.isDesktop?i("el-table-column",{attrs:{label:e.$t("invites.id"),"min-width":"60",prop:"id",sortable:""}}):e._e(),e._v(" "),i("el-table-column",{attrs:{label:e.$t("invites.token"),"min-width":e.isDesktop?320:120,prop:"token"}}),e._v(" "),e.isDesktop?i("el-table-column",{attrs:{label:e.$t("invites.expiresAt"),align:"center","header-align":"center","min-width":"110",prop:"expires_at",sortable:""}}):e._e(),e._v(" "),i("el-table-column",{attrs:{label:e.$t("invites.maxUse"),align:"center","header-align":"center","min-width":"60",prop:"max_use",sortable:""}}),e._v(" "),e.isDesktop?i("el-table-column",{attrs:{label:e.$t("invites.uses"),align:"center","header-align":"center","min-width":"60",prop:"uses"}}):e._e(),e._v(" "),i("el-table-column",{attrs:{label:e.$t("invites.used"),"min-width":e.isDesktop?60:50,align:"center","header-align":"center",prop:"used",sortable:""},scopedSlots:e._u([{key:"default",fn:function(t){return[i("el-tag",{attrs:{type:t.row.used?"danger":"success","disable-transitions":""}},[e._v("\n          "+e._s(t.row.used?e.$t("invites.used"):e.$t("invites.active"))+"\n        ")])]}}])}),e._v(" "),i("el-table-column",{attrs:{label:e.$t("invites.actions"),"min-width":e.isDesktop?100:50,align:"center","header-align":"center"},scopedSlots:e._u([{key:"default",fn:function(t){return[i("el-button",{attrs:{type:"text",size:"small"},nativeOn:{click:function(i){return e.revokeInviteToken(t.row.token)}}},[e._v("\n          "+e._s(e.$t("invites.revoke"))+"\n        ")])]}}])})],1)],1)},[],!1,null,null,null);k.options.__file="index.vue";t.default=k.exports},ObxI:function(e,t,i){"use strict";var n=i("Tykb");i.n(n).a},Tykb:function(e,t,i){}}]);
//# sourceMappingURL=chunk-7c6b.56a14571.js.map