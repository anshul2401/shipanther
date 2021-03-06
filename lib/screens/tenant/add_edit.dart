import 'package:flutter/material.dart';
import 'package:shipanther/bloc/tenant/tenant_bloc.dart';
import 'package:smart_select/smart_select.dart';
import 'package:trober_sdk/api.dart';

class TenantAddEdit extends StatefulWidget {
  final Tenant tenant;
  final TenantBloc tenantBloc;
  final bool isEdit;

  TenantAddEdit({
    Key key,
    @required this.tenant,
    @required this.tenantBloc,
    @required this.isEdit,
  });

  @override
  _TenantAddEditState createState() => _TenantAddEditState();
}

class _TenantAddEditState extends State<TenantAddEdit> {
  static final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String _tenantName;
  TenantType _tenantType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isEdit ? "Edit tenant" : "Add new tenant",
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.disabled,
          onWillPop: () {
            return Future(() => true);
          },
          child: ListView(
            children: [
              TextFormField(
                initialValue: widget.tenant.name ?? '',
                //key: ArchSampleKeys.containerNameField,
                autofocus: widget.isEdit ? false : true,
                style: Theme.of(context).textTheme.headline5,
                decoration: InputDecoration(hintText: 'Tenant Name'
                    //ArchSampleLocalizations.of(context).containerNameHint,
                    ),
                validator: (val) => val.trim().isEmpty
                    ? "Tenant name should not be empty" //ArchSampleLocalizations.of(context).emptyTenantError
                    : null,
                onSaved: (value) => _tenantName = value,
              ),
              SmartSelect<TenantType>.single(
                title:
                    "Tenant type", //ArchSampleLocalizations.of(context).fromHint,
                // key: ArchSampleKeys.fromField,
                onChange: (state) => _tenantType = state.value,
                choiceItems: S2Choice.listFrom<TenantType, TenantType>(
                  source: TenantType.values,
                  value: (index, item) => item,
                  title: (index, item) => item.toString(),
                ),
                modalType: S2ModalType.popupDialog,
                modalHeader: false,
                tileBuilder: (context, state) {
                  return S2Tile.fromState(
                    state,
                    trailing: const Icon(Icons.arrow_drop_down),
                    isTwoLine: true,
                  );
                },
                value: widget.tenant.type ?? TenantType.production,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // key: isEditing
        //     ? ArchSampleKeys.saveTenantFab
        //     : ArchSampleKeys.saveNewTenant,
        tooltip: widget.isEdit
            ? "Edit" //ArchSampleLocalizations.of(context).saveChanges
            : "Create", //ArchSampleLocalizations.of(context).addTenant,
        child: Icon(widget.isEdit ? Icons.check : Icons.add),
        onPressed: () {
          final form = formKey.currentState;
          if (form.validate()) {
            form.save();
            widget.tenant.name = _tenantName;
            widget.tenant.type = _tenantType;
            if (widget.isEdit) {
              widget.tenantBloc
                  .add(UpdateTenant(widget.tenant.id, widget.tenant));
            } else {
              widget.tenantBloc.add(CreateTenant(widget.tenant));
            }

            Navigator.pop(context);
          }
        },
      ),
    );
  }
}
