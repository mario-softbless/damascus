<%-- <dmsc:root  templateName="Portlet_XXXXWEB_view.jsp.ftl" /> --%>
<%-- <dmsc:sync id="head-common" > --%>
<#include "./valuables.ftl">
<#assign createPath = "${webModulePath}/src/main/resources/META-INF/resources/${snakecaseModel}/view.jsp">
<#assign skipTemplate = !generateWeb>
<%-- </dmsc:sync> --%>
<%@ include file="./init.jsp" %>

<%
String iconChecked = "checked";
String iconUnchecked = "unchecked";
SimpleDateFormat dateFormat = new SimpleDateFormat(dateFormatVal);
SimpleDateFormat dateTimeFormat = new SimpleDateFormat(datetimeFormatVal);

${capFirstModel}DisplayContext ${uncapFirstModel}DisplayContext = (${capFirstModel}DisplayContext)request.getAttribute(${capFirstModel}WebKeys.${uppercaseModel}_DISPLAY_CONTEXT);

String displayStyle = ${uncapFirstModel}DisplayContext.getDisplayStyle();
SearchContainer entriesSearchContainer = ${uncapFirstModel}DisplayContext.getSearchContainer();

PortletURL portletURL = entriesSearchContainer.getIteratorURL();

${capFirstModel}ManagementToolbarDisplayContext ${uncapFirstModel}ManagementToolbarDisplayContext = new ${capFirstModel}ManagementToolbarDisplayContext(liferayPortletRequest, liferayPortletResponse, request, entriesSearchContainer, trashHelper, displayStyle);
%>

<clay:management-toolbar
	actionDropdownItems="<%= ${uncapFirstModel}ManagementToolbarDisplayContext.getActionDropdownItems() %>"
	clearResultsURL="<%= ${uncapFirstModel}ManagementToolbarDisplayContext.getSearchActionURL() %>"
	componentId="${uncapFirstModel}ManagementToolbar"
	creationMenu="<%= ${uncapFirstModel}ManagementToolbarDisplayContext.getCreationMenu() %>"
	disabled="<%= ${uncapFirstModel}ManagementToolbarDisplayContext.isDisabled() %>"
	filterDropdownItems="<%= ${uncapFirstModel}ManagementToolbarDisplayContext.getFilterDropdownItems() %>"
	itemsTotal="<%= ${uncapFirstModel}ManagementToolbarDisplayContext.getItemsTotal() %>"
	searchActionURL="<%= ${uncapFirstModel}ManagementToolbarDisplayContext.getSearchActionURL() %>"
	searchContainerId="${uncapFirstModel}"
	searchFormName="fm"
	showSearch="true"
	sortingOrder="<%= ${uncapFirstModel}ManagementToolbarDisplayContext.getOrderByType() %>"
	sortingURL="<%= ${uncapFirstModel}ManagementToolbarDisplayContext.getSortingURL() %>"
/>

<portlet:actionURL name="/${lowercaseModel}/crud" var="restoreTrashEntriesURL">
	<portlet:param name="<%= Constants.CMD %>" value="<%= Constants.RESTORE %>" />
</portlet:actionURL>

<liferay-trash:undo
	portletURL="<%= restoreTrashEntriesURL %>"
/>

<div class="container-fluid container-fluid-max-xl main-content-body">
	<aui:form action="<%= portletURL.toString() %>" method="get" name="fm">
		<aui:input name="<%= Constants.CMD %>" type="hidden" />
		<aui:input name="redirect" type="hidden" value="<%= portletURL.toString() %>" />
		<aui:input name="deleteEntryIds" type="hidden" />
		<aui:input name="selectAll" type="hidden" value="<%= false %>" />

		<liferay-ui:search-container
			emptyResultsMessage="no-record-was-found"
			id="${uncapFirstModel}"
			rowChecker="<%= new EmptyOnClickRowChecker(renderResponse) %>"
			searchContainer="<%= entriesSearchContainer %>"
		>
			<liferay-ui:search-container-row
				className="${packageName}.model.${capFirstModel}"
				escapedModel="<%= true %>"
				keyProperty="${lowercaseModel}Id"
				modelVar="${uncapFirstModel}"
			>
<%-- <dmsc:sync id="view-search-rows" > --%>
			<#-- ---------------- -->
			<#-- field loop start -->
			<#-- ---------------- -->
			<#list application.fields as field >
				<#-- ---------------- -->
				<#--     Long         -->
				<#--     Varchar      -->
				<#--     Boolean      -->
				<#--     Double       -->
				<#-- Document Library -->
				<#--     Integer      -->
				<#-- ---------------- -->
					<#if
					field.type?string == "com.liferay.damascus.cli.json.fields.Long"     		||
					field.type?string == "com.liferay.damascus.cli.json.fields.Varchar"  		||
					field.type?string == "com.liferay.damascus.cli.json.fields.Boolean"  		||
					field.type?string == "com.liferay.damascus.cli.json.fields.Double"   		||
					field.type?string == "com.liferay.damascus.cli.json.fields.DocumentLibrary" ||
					field.type?string == "com.liferay.damascus.cli.json.fields.Integer"
					>
				<liferay-ui:search-container-column-text
					align="left"
					name="${field.name?cap_first}"
					orderable="true"
					orderableProperty="${field.name}"
					property="${field.name}"
				/>

					</#if>
				<#-- ---------------- -->
				<#--     Date         -->
				<#--     DateTime     -->
				<#-- ---------------- -->
					<#if
					field.type?string == "com.liferay.damascus.cli.json.fields.Date"     ||
					field.type?string == "com.liferay.damascus.cli.json.fields.DateTime"
					>
				<liferay-ui:search-container-column-text
					name="${field.name?cap_first}"
					value="<%= dateFormat.format(${uncapFirstModel}.get${field.name?cap_first}()) %>"
					orderable="true"
					orderableProperty="${field.name}"
					align="left"
				/>
					</#if>

				<#-- ---------------- -->
				<#--     RichText     -->
				<#--       Text       -->
				<#-- ---------------- -->
					<#if
					field.type?string == "com.liferay.damascus.cli.json.fields.RichText" ||
					field.type?string == "com.liferay.damascus.cli.json.fields.Text"
					>
				<liferay-ui:search-container-column-text name="${field.name?cap_first}"
														 align="center">
					<%
					String ${field.name}Icon = iconUnchecked;
					String ${field.name} = ${uncapFirstModel}.get${field.name?cap_first}();
					if (!${field.name}.equals("")) {
						${field.name}Icon= iconChecked;
					}
					%>
					<liferay-ui:icon image="<%= ${field.name}Icon %>" />
				</liferay-ui:search-container-column-text>
					</#if>
			</#list>
			<#-- ---------------- -->
			<#-- field loop ends  -->
			<#-- ---------------- -->
<%-- </dmsc:sync> --%>
				<liferay-ui:search-container-column-jsp
					align="right"
					path="/${snakecaseModel}/edit_actions.jsp"
				/>
			</liferay-ui:search-container-row>

			<liferay-ui:search-iterator displayStyle="list" markupView="lexicon" />
		</liferay-ui:search-container>
	</aui:form>
</div>

<aui:script>
	function <portlet:namespace />deleteEntries() {
		if (<%=trashHelper.isTrashEnabled(scopeGroupId) %> || confirm('<%=UnicodeLanguageUtil.get(request, "are-you-sure-you-want-to-delete-the-selected-entries") %>')) {
			var form = AUI.$(document.<portlet:namespace />fm);

			form.attr('method', 'post');
			form.fm('<%=Constants.CMD%>').val('<%=trashHelper.isTrashEnabled(scopeGroupId) ? Constants.MOVE_TO_TRASH : Constants.DELETE%>');
			form.fm('deleteEntryIds').val(Liferay.Util.listCheckedExcept(form, '<portlet:namespace />allRowIds'));

			submitForm(form, '<portlet:actionURL name="/${lowercaseModel}/crud" />');
		}
	}
</aui:script>