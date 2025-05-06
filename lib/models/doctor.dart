
class LoggedDoctor {
  int _id;
  String _name;
  String _crm;
  LoggedDoctor(this._id, this._name, this._crm);

  int get id => _id;
  String get name => _name;
  String get crm => crm;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = _id;
    map["name"] = _name;
    map["crm"] = _crm;

    return map;
  }

  @override
  String toString() {
    return 'Doctor {id: ${id}, name: ${name}, crm: ${crm}}';
  }

}